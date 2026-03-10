# ABAP Movie Ticket Booking System (Managed Scenario)

## Project Overview

The **ABAP Movie Ticket Booking System** is developed using the **ABAP RESTful Application Programming Model (RAP)** with a **Managed Scenario**. The system allows users to manage movie ticket bookings through a modern **SAP Fiori-based interface**.

This application demonstrates how RAP simplifies application development by automatically handling **Create, Read, Update, and Delete (CRUD)** operations using the **managed behavior implementation** provided by the RAP framework.

The system enables users to book movie tickets, view booking details, update booking information, and cancel bookings easily.

---

## Objectives

The main objectives of this project are:

* To develop a **Movie Ticket Booking System using SAP RAP**.
* To demonstrate the **Managed Scenario implementation in RAP**.
* To manage movie booking records efficiently.
* To create a **Fiori-based user interface** for booking management.
* To understand RAP architecture and business object modeling.

---

## Technologies Used

* **ABAP RESTful Application Programming Model (RAP)**
* **Core Data Services (CDS)**
* **Behavior Definition (Managed Implementation)**
* **Behavior Projection**
* **Service Definition**
* **Service Binding (OData V4)**
* **SAP Fiori Elements**

---

## System Architecture

The application follows the standard **RAP layered architecture**:

1. **Database Table**

   * Stores movie ticket booking information.

2. **Interface CDS View**

   * Defines the business object interface.

3. **Projection CDS View**

   * Used for UI consumption.

4. **Behavior Definition (Managed Scenario)**

   * Automatically manages CRUD operations.

5. **Service Definition**

   * Exposes the business object.

6. **Service Binding**

   * Connects the application to the Fiori UI using OData services.

---

## Key Features

* Book movie tickets
* View booking details
* Update booking information
* Cancel movie ticket bookings
* Fiori-based user interface
* Automatic CRUD operations using RAP managed behavior

---

## Booking Data Fields

| Field Name    | Description                        |
| ------------- | ---------------------------------- |
| Booking_ID    | Unique identifier for each booking |
| Customer_Name | Name of the customer               |
| Movie_Name    | Name of the movie                  |
| Show_Time     | Time of the movie show             |
| Seat_Number   | Seat number assigned               |
| Ticket_Price  | Price of the ticket                |

---

