# STX-VaxChain - Vaccine Tracking Smart Contract

## Overview

The Vaccine Tracking Smart Contract is a decentralized application (DApp) that helps manage the lifecycle of vaccine shipments, immunizations, clinicians, and storage facilities. It ensures secure and transparent vaccine distribution by tracking vaccine shipments, recording immunizations, and monitoring cold-chain conditions. The contract enforces role-based access control and ensures compliance with minimum intervals for immunizations and cold-chain temperature requirements.

## Features

- **System Control:** Only the system controller can manage critical operations.
- **Clinician Registration:** Allows the registration of clinicians with roles and facility details.
- **Vaccine Shipment Management:** Allows the registration and tracking of vaccine shipments, including manufacturer details, storage conditions, and temperature violations.
- **Immunization Tracking:** Records immunizations, ensuring that recipients receive vaccines at the correct time, and tracks their immunization history.
- **Cold Chain Monitoring:** Tracks the storage conditions of vaccines to ensure they are kept within temperature requirements. Records violations and flags compromised shipments.
- **Error Handling:** Various error codes for invalid operations, such as unauthorized actions, expired vaccines, or violations of the cold chain.

## Components

### 1. **System Control**
- **Controller Management:** Only the designated system controller can transfer system control to another authorized entity.

### 2. **Clinician Management**
- **Clinician Registration:** Clinicians can be registered with their role, facility name, and credential expiry.

### 3. **Vaccine Shipment Management**
- **Shipment Registration:** Vaccines can be registered with details such as manufacturer information, production date, expiry date, available doses, and storage temperature.
- **Shipment Status Update:** The status of vaccine shipments can be updated to reflect their current condition (e.g., active, compromised).
- **Temperature Violation Tracking:** Tracks temperature violations that occur during the storage or transportation of vaccine shipments.

### 4. **Immunization Management**
- **Immunization Registration:** Recipients can be registered for immunizations. The system tracks each dose and ensures the minimum interval between doses is met.
- **Adverse Event Reporting:** Recipients can report adverse events after receiving a vaccine.

### 5. **Cold Chain Facilities**
- **Facility Registration:** Cold chain facilities can be registered, including storage capacity and location.
- **Temperature Monitoring:** The temperature inside the storage facility is monitored to ensure compliance with cold-chain requirements.

## Error Codes

- **AUTHORIZATION-ERROR (u100):** Error when an unauthorized action is attempted.
- **INVALID-VACCINE-SHIPMENT (u101):** Invalid shipment details.
- **DUPLICATE-SHIPMENT-ERROR (u102):** Attempt to register a duplicate shipment.
- **SHIPMENT-NOT-FOUND-ERROR (u103):** Shipment not found.
- **VACCINE-SUPPLY-DEPLETED (u104):** Vaccine supply has been depleted.
- **INVALID-RECIPIENT-ID (u105):** Invalid recipient ID.
- **DUPLICATE-IMMUNIZATION (u106):** Attempt to register a duplicate immunization.
- **COLD-CHAIN-BREACH (u107):** Temperature violation in cold chain.
- **EXPIRED-VACCINE-ERROR (u108):** Vaccine has expired.
- **INVALID-CLINIC-LOCATION (u109):** Invalid clinic location.
- **IMMUNIZATION-LIMIT-REACHED (u110):** Maximum number of immunizations reached.
- **MINIMUM-INTERVAL-VIOLATION (u111):** Minimum dose interval violated.
- **ADMIN-PRIVILEGES-REQUIRED (u112):** Admin privileges required for the action.
- **DATA-VALIDATION-ERROR (u113):** Invalid input data.
- **EXPIRY-DATE-ERROR (u114):** Invalid expiry date.
- **STORAGE-CAPACITY-ERROR (u115):** Insufficient storage capacity.
- **CLINICIAN-ALREADY-REGISTERED (u116):** Clinician already registered.

## Contract Structure

- **System Control:** Manages access control and system administration.
- **Clinicians:** Registered professionals who can manage vaccine shipments and immunizations.
- **Vaccine Shipments:** Includes all details related to vaccine shipments, such as manufacturer, brand, expiration date, and storage conditions.
- **Immunization Records:** Tracks immunizations for recipients, including dose sequence and medical exemption details.
- **Cold Chain Facilities:** Manages facilities storing vaccines with cold chain monitoring.

## Public Functions

- **transfer-system-control:** Transfers control of the system to a new controller.
- **register-clinician:** Registers a new clinician with role and facility details.
- **register-storage-facility:** Registers a cold chain facility with storage capacity and location.
- **register-vaccine-shipment:** Registers a new vaccine shipment with relevant details.
- **update-shipment-status:** Updates the status of a vaccine shipment.
- **record-temperature-violation:** Records a temperature violation for a vaccine shipment.
- **record-immunization:** Records an immunization for a recipient.

## Read-Only Functions

- **get-system-controller:** Returns the current system controller.
- **verify-clinician-status:** Verifies if a clinician is authorized.
- **get-shipment-details:** Retrieves details about a specific vaccine shipment.
- **get-recipient-record:** Retrieves immunization records for a recipient.
- **get-facility-details:** Retrieves details of a specific cold chain facility.
- **verify-vaccine-validity:** Verifies if a vaccine shipment is still valid.