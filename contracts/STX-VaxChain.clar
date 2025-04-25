;; Vaccine Tracking Smart Contract

;; Contract Owner Management
(define-data-var immunization-system-controller principal tx-sender)

;; Error Codes
(define-constant AUTHORIZATION-ERROR (err u100))
(define-constant INVALID-VACCINE-SHIPMENT (err u101))
(define-constant DUPLICATE-SHIPMENT-ERROR (err u102))
(define-constant SHIPMENT-NOT-FOUND-ERROR (err u103))
(define-constant VACCINE-SUPPLY-DEPLETED (err u104))
(define-constant INVALID-RECIPIENT-ID (err u105))
(define-constant DUPLICATE-IMMUNIZATION (err u106))
(define-constant COLD-CHAIN-BREACH (err u107))
(define-constant EXPIRED-VACCINE-ERROR (err u108))
(define-constant INVALID-CLINIC-LOCATION (err u109))
(define-constant IMMUNIZATION-LIMIT-REACHED (err u110))
(define-constant MINIMUM-INTERVAL-VIOLATION (err u111))
(define-constant ADMIN-PRIVILEGES-REQUIRED (err u112))
(define-constant DATA-VALIDATION-ERROR (err u113))
(define-constant EXPIRY-DATE-ERROR (err u114))
(define-constant STORAGE-CAPACITY-ERROR (err u115))
(define-constant CLINICIAN-ALREADY-REGISTERED (err u116))

;; Constants
(define-constant COLD-CHAIN-MINIMUM-TEMP (- 70))
(define-constant COLD-CHAIN-MAXIMUM-TEMP 8)
(define-constant DOSE-INTERVAL-REQUIREMENT u21) ;; 21 days minimum between doses
(define-constant MAXIMUM-IMMUNIZATION-SERIES u4)
(define-constant MINIMUM-ENTRY-LENGTH u1)
(define-constant CURRENT-CHAIN-HEIGHT block-height)

;; Data Maps
(define-map vaccine-shipment-registry
    { shipment-id: (string-ascii 32) }
    {
        manufacturer-details: (string-ascii 50),
        vaccine-brand-name: (string-ascii 50),
        production-timestamp: uint,
        expiration-timestamp: uint,
        available-unit-count: uint,
        storage-temp-celsius: int,
        shipment-status: (string-ascii 20),
        temp-violation-incidents: uint,
        storage-facility-id: (string-ascii 100),
        shipment-notes: (string-ascii 500)
    }
)

(define-map immunization-registry
    { recipient-id: (string-ascii 32) }
    {
        immunization-sequence: (list 10 {
            shipment-reference: (string-ascii 32),
            administration-timestamp: uint,
            vaccine-formulation: (string-ascii 50),
            sequence-number: uint,
            administering-clinician: principal,
            clinic-location: (string-ascii 100),
            next-dose-due-date: (optional uint)
        }),
        completed-immunizations: uint,
        adverse-event-reports: (list 5 (string-ascii 200)),
        medical-exemption: (optional (string-ascii 200))
    }
)

(define-map authorized-clinicians 
    principal 
    {
        clinical-role: (string-ascii 20),
        clinic-name: (string-ascii 100),
        credentials-valid-until: uint
    }
)

(define-map cold-chain-facilities
    (string-ascii 100)
    {
        facility-location: (string-ascii 200),
        max-storage-units: uint,
        current-unit-count: uint,
        temperature-monitoring: (list 100 {
            monitoring-timestamp: uint,
            recorded-temp-celsius: int
        })
    }
)

;; Private Functions
(define-private (is-system-controller)
    (is-eq tx-sender (var-get immunization-system-controller))
)

;; String validation functions
(define-private (validate-identifier (input (string-ascii 32)))
    (> (len input) MINIMUM-ENTRY-LENGTH)
)

(define-private (validate-name-field (input (string-ascii 50)))
    (> (len input) MINIMUM-ENTRY-LENGTH)
)

(define-private (validate-location-field (input (string-ascii 100)))
    (> (len input) MINIMUM-ENTRY-LENGTH)
)

(define-private (validate-description-field (input (string-ascii 200)))
    (> (len input) MINIMUM-ENTRY-LENGTH)
)

(define-private (validate-future-date (input-date uint))
    (> input-date CURRENT-CHAIN-HEIGHT)
)

(define-private (validate-storage-limit (proposed-limit uint))
    (> proposed-limit u0)
)

;; Read-only Functions
(define-read-only (get-system-controller)
    (ok (var-get immunization-system-controller))
)

(define-read-only (verify-clinician-status (clinician-address principal))
    (match (map-get? authorized-clinicians clinician-address)
        clinician-data (>= (get credentials-valid-until clinician-data) CURRENT-CHAIN-HEIGHT)
        false
    )
)

;; Public Functions
(define-public (transfer-system-control (new-controller principal))
    (begin
        (asserts! (is-system-controller) ADMIN-PRIVILEGES-REQUIRED)
        (asserts! (is-some (map-get? authorized-clinicians new-controller)) AUTHORIZATION-ERROR)
        (ok (var-set immunization-system-controller new-controller))
    )
)

(define-public (register-clinician 
    (clinician-address principal)
    (role (string-ascii 20))
    (facility-name (string-ascii 100))
    (credential-expiry uint))
    (begin
        (asserts! (is-system-controller) AUTHORIZATION-ERROR)
        (asserts! (is-none (map-get? authorized-clinicians clinician-address)) CLINICIAN-ALREADY-REGISTERED)
        (asserts! (validate-identifier role) DATA-VALIDATION-ERROR)
        (asserts! (validate-location-field facility-name) DATA-VALIDATION-ERROR)
        (asserts! (validate-future-date credential-expiry) EXPIRY-DATE-ERROR)
        (ok (map-set authorized-clinicians 
            clinician-address 
            {
                clinical-role: role,
                clinic-name: facility-name,
                credentials-valid-until: credential-expiry
            }))
    )
)

