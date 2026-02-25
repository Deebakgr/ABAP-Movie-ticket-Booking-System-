CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Booking
      RESULT result.

    METHODS validateCustomerEmail FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateCustomerEmail.

    METHODS validateCustomerPhone FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateCustomerPhone.

    METHODS validateNoOfTickets FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateNoOfTickets.

    METHODS validateSeatAvailability FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateSeatAvailability.

    METHODS calculateTotalAmount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalAmount.

    METHODS setBookingDate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~setBookingDate.

    METHODS setDefaultStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~setDefaultStatus.

    METHODS updateShowSeats FOR DETERMINE ON SAVE
      IMPORTING keys FOR Booking~updateShowSeats.

    METHODS confirmBooking FOR MODIFY
      IMPORTING keys FOR ACTION Booking~confirmBooking
      RESULT result.

    METHODS cancelBooking FOR MODIFY
      IMPORTING keys FOR ACTION Booking~cancelBooking
      RESULT result.

    METHODS generateTicket FOR MODIFY
      IMPORTING keys FOR ACTION Booking~generateTicket
      RESULT result.

    METHODS resetTicket FOR MODIFY
      IMPORTING keys FOR ACTION Booking~resetTicket
      RESULT result.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD get_global_authorizations.
    result-%create = if_abap_behv=>auth-allowed.
    result-%update = if_abap_behv=>auth-allowed.
    result-%delete = if_abap_behv=>auth-allowed.
  ENDMETHOD.

  METHOD validateCustomerEmail.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        FIELDS ( CustomerEmail )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    LOOP AT lt_bookings INTO DATA(ls_booking).
      IF ls_booking-CustomerEmail IS INITIAL.
        APPEND VALUE #(
          %tky = ls_booking-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Customer Email cannot be blank!' )
        ) TO reported-booking.
        APPEND VALUE #( %tky = ls_booking-%tky ) TO failed-booking.
      ELSEIF NOT ls_booking-CustomerEmail CA '@'.
        APPEND VALUE #(
          %tky = ls_booking-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Invalid Email! @ symbol is required.' )
        ) TO reported-booking.
        APPEND VALUE #( %tky = ls_booking-%tky ) TO failed-booking.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCustomerPhone.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        FIELDS ( CustomerPhone )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    LOOP AT lt_bookings INTO DATA(ls_booking).
      IF ls_booking-CustomerPhone IS INITIAL.
        APPEND VALUE #(
          %tky = ls_booking-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Customer Phone cannot be blank!' )
        ) TO reported-booking.
        APPEND VALUE #( %tky = ls_booking-%tky ) TO failed-booking.
      ELSEIF strlen( ls_booking-CustomerPhone ) < 10.
        APPEND VALUE #(
          %tky = ls_booking-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Phone must be at least 10 digits!' )
        ) TO reported-booking.
        APPEND VALUE #( %tky = ls_booking-%tky ) TO failed-booking.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateNoOfTickets.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        FIELDS ( NoOfTickets )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    LOOP AT lt_bookings INTO DATA(ls_booking).
      CHECK ls_booking-NoOfTickets IS NOT INITIAL.

      IF ls_booking-NoOfTickets <= 0.
        APPEND VALUE #(
          %tky = ls_booking-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Number of Tickets must be greater than zero!' )
        ) TO reported-booking.
        APPEND VALUE #( %tky = ls_booking-%tky ) TO failed-booking.
      ELSEIF ls_booking-NoOfTickets > 10.
        APPEND VALUE #(
          %tky = ls_booking-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Maximum 10 tickets allowed per booking!' )
        ) TO reported-booking.
        APPEND VALUE #( %tky = ls_booking-%tky ) TO failed-booking.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateSeatAvailability.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        FIELDS ( ShowId NoOfTickets )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    DATA lv_available TYPE zshow_t-available_seats.

    LOOP AT lt_bookings INTO DATA(ls_booking).
      CHECK ls_booking-ShowId IS NOT INITIAL.
      CHECK ls_booking-NoOfTickets > 0.
      CLEAR lv_available.

      SELECT SINGLE available_seats
        FROM zshow_t
        WHERE show_id = @ls_booking-ShowId
        INTO @lv_available.

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF lv_available < ls_booking-NoOfTickets.
        APPEND VALUE #(
          %tky = ls_booking-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = |Only { lv_available } seats available!| )
        ) TO reported-booking.
        APPEND VALUE #( %tky = ls_booking-%tky ) TO failed-booking.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD calculateTotalAmount.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        FIELDS ( ShowId NoOfTickets )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_BOOKING\\Booking.
    DATA lv_price  TYPE zshow_t-ticket_price.
    DATA lv_movie  TYPE zshow_t-movie_id.
    DATA lv_screen TYPE zshow_t-screen_id.
    DATA lv_total  TYPE zbooking_t-total_amount.

    LOOP AT lt_bookings INTO DATA(ls_booking).
      CHECK ls_booking-ShowId IS NOT INITIAL.
      CHECK ls_booking-NoOfTickets > 0.
      CLEAR: lv_price, lv_movie, lv_screen, lv_total.

      SELECT SINGLE ticket_price
        FROM zshow_t
        WHERE show_id = @ls_booking-ShowId
        INTO @lv_price.

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      SELECT SINGLE movie_id
        FROM zshow_t
        WHERE show_id = @ls_booking-ShowId
        INTO @lv_movie.

      SELECT SINGLE screen_id
        FROM zshow_t
        WHERE show_id = @ls_booking-ShowId
        INTO @lv_screen.

      lv_total = lv_price * ls_booking-NoOfTickets.

      APPEND VALUE #(
        %tky        = ls_booking-%tky
        TotalAmount = lv_total
        MovieId     = lv_movie
        ScreenId    = lv_screen
      ) TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( TotalAmount MovieId ScreenId )
        WITH lt_update
      REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD setBookingDate.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        FIELDS ( BookingDate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_BOOKING\\Booking.
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_bookings INTO DATA(ls_booking).
      IF ls_booking-BookingDate IS INITIAL.
        APPEND VALUE #(
          %tky        = ls_booking-%tky
          BookingDate = lv_today
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( BookingDate )
        WITH lt_update
      REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD setDefaultStatus.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        FIELDS ( BookingStatus PaymentStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_BOOKING\\Booking.

    LOOP AT lt_bookings INTO DATA(ls_booking).
      IF ls_booking-BookingStatus IS INITIAL.
        APPEND VALUE #(
          %tky          = ls_booking-%tky
          BookingStatus = 'PENDING'
          PaymentStatus = 'UNPAID'
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( BookingStatus PaymentStatus )
        WITH lt_update
      REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD updateShowSeats.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        FIELDS ( ShowId NoOfTickets BookingStatus )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    DATA lv_seats     TYPE zshow_t-available_seats.
    DATA lv_new_seats TYPE zshow_t-available_seats.

    LOOP AT lt_bookings INTO DATA(ls_booking).
      IF ls_booking-BookingStatus = 'CONFIRMED'.
        CLEAR: lv_seats, lv_new_seats.

        SELECT SINGLE available_seats
          FROM zshow_t
          WHERE show_id = @ls_booking-ShowId
          INTO @lv_seats.

        lv_new_seats = lv_seats - ls_booking-NoOfTickets.
        IF lv_new_seats < 0.
          lv_new_seats = 0.
        ENDIF.

        UPDATE zshow_t
          SET available_seats = @lv_new_seats
          WHERE show_id       = @ls_booking-ShowId.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD confirmBooking.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_BOOKING\\Booking.

    LOOP AT lt_bookings INTO DATA(ls_booking).
      APPEND VALUE #(
        %tky          = ls_booking-%tky
        BookingStatus = 'CONFIRMED'
        PaymentStatus = 'PAID'
      ) TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( BookingStatus PaymentStatus )
        WITH lt_update
      REPORTED DATA(lt_reported)
      FAILED   DATA(lt_failed).

    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls_res IN lt_result
                      ( %tky   = ls_res-%tky
                        %param = ls_res ) ).
  ENDMETHOD.

  METHOD cancelBooking.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_BOOKING\\Booking.

    LOOP AT lt_bookings INTO DATA(ls_booking).
      APPEND VALUE #(
        %tky          = ls_booking-%tky
        BookingStatus = 'CANCELLED'
        PaymentStatus = 'REFUNDED'
      ) TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS ( BookingStatus PaymentStatus )
        WITH lt_update
      REPORTED DATA(lt_reported)
      FAILED   DATA(lt_failed).

    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls_res IN lt_result
                      ( %tky   = ls_res-%tky
                        %param = ls_res ) ).
  ENDMETHOD.

  METHOD generateTicket.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    DATA lt_update     TYPE TABLE FOR UPDATE ZI_BOOKING\\Booking.
    DATA lv_movie_name TYPE zmovie_t-movie_name.
    DATA lv_screen_name TYPE zscreen_t-screen_name.

    "-- ✅ FIXED: Each seat field declared separately
    DATA lv_seat_num   TYPE zseat_t-seat_number.
    DATA lv_seat_row   TYPE zseat_t-seat_row.
    DATA lv_seat_cat   TYPE zseat_t-seat_category.
    DATA lv_show_date  TYPE zshow_t-show_date.
    DATA lv_show_time  TYPE zshow_t-show_time.
    DATA lv_ticket_num TYPE zbooking_t-ticket_number.
    DATA lv_date_str   TYPE string.
    DATA lv_counter    TYPE i VALUE 0.

    LOOP AT lt_bookings INTO DATA(ls_booking).

      IF ls_booking-BookingStatus <> 'CONFIRMED'.
        APPEND VALUE #(
          %tky = ls_booking-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Ticket can only be generated for CONFIRMED bookings!' )
        ) TO reported-booking.
        APPEND VALUE #( %tky = ls_booking-%tky ) TO failed-booking.
        CONTINUE.
      ENDIF.

      IF ls_booking-TicketGenerated = 'X'.
        APPEND VALUE #(
          %tky = ls_booking-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-warning
                   text     = |Ticket { ls_booking-TicketNumber } already generated!| )
        ) TO reported-booking.
        CONTINUE.
      ENDIF.

      CLEAR: lv_movie_name, lv_screen_name,
             lv_seat_num, lv_seat_row, lv_seat_cat,
             lv_show_date, lv_show_time, lv_ticket_num.

      "-- Fetch Movie Name
      SELECT SINGLE movie_name
        FROM zmovie_t
        WHERE movie_id = @ls_booking-MovieId
        INTO @lv_movie_name.

      "-- Fetch Screen Name
      SELECT SINGLE screen_name
        FROM zscreen_t
        WHERE screen_id = @ls_booking-ScreenId
        INTO @lv_screen_name.

      "-- ✅ FIXED: Fetch each seat field SEPARATELY
      SELECT SINGLE seat_number
        FROM zseat_t
        WHERE seat_id = @ls_booking-SeatId
        INTO @lv_seat_num.

      SELECT SINGLE seat_row
        FROM zseat_t
        WHERE seat_id = @ls_booking-SeatId
        INTO @lv_seat_row.

      SELECT SINGLE seat_category
        FROM zseat_t
        WHERE seat_id = @ls_booking-SeatId
        INTO @lv_seat_cat.

      "-- ✅ FIXED: Fetch each show field SEPARATELY
      SELECT SINGLE show_date
        FROM zshow_t
        WHERE show_id = @ls_booking-ShowId
        INTO @lv_show_date.

      SELECT SINGLE show_time
        FROM zshow_t
        WHERE show_id = @ls_booking-ShowId
        INTO @lv_show_time.

     "-- Generate Ticket Number
      lv_counter    = lv_counter + 1.

      " Get current Date and Time using ABAP Cloud standards
      DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
      DATA(lv_time) = cl_abap_context_info=>get_system_time( ).

      " Format: TKT + YYYYMMDD + HHMMSS + Loop Counter
      " Example output: TKT202603161430051
      lv_ticket_num = |TKT{ lv_date }{ lv_time }{ lv_counter }|.

      APPEND VALUE #(
        %tky               = ls_booking-%tky
        TicketNumber       = lv_ticket_num
        TicketGenerated    = 'X'
        TicketMovieName    = lv_movie_name
        TicketScreenName   = lv_screen_name
        TicketSeatNumber   = lv_seat_num
        TicketSeatRow      = lv_seat_row
        TicketSeatCategory = lv_seat_cat
        TicketShowDate     = lv_show_date
        TicketShowTime     = lv_show_time
      ) TO lt_update.

      APPEND VALUE #(
        %tky = ls_booking-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-success
                 text     = |Ticket Generated Successfully! No: { lv_ticket_num }| )
      ) TO reported-booking.

    ENDLOOP.

    MODIFY ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS (
          TicketNumber       TicketGenerated
          TicketMovieName    TicketScreenName
          TicketSeatNumber   TicketSeatRow
          TicketSeatCategory TicketShowDate
          TicketShowTime
        )
        WITH lt_update
      REPORTED DATA(lt_reported)
      FAILED   DATA(lt_failed).

    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls_res IN lt_result
                      ( %tky   = ls_res-%tky
                        %param = ls_res ) ).
  ENDMETHOD.

  METHOD resetTicket.
    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_bookings).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_BOOKING\\Booking.

    LOOP AT lt_bookings INTO DATA(ls_booking).
      APPEND VALUE #(
        %tky               = ls_booking-%tky
        TicketGenerated    = ''
        TicketNumber       = ''
        TicketMovieName    = ''
        TicketScreenName   = ''
        TicketSeatNumber   = ''
        TicketSeatRow      = ''
        TicketSeatCategory = ''
        TicketShowDate     = '00000000'
        TicketShowTime     = '000000'
      ) TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        UPDATE FIELDS (
          TicketGenerated    TicketNumber
          TicketMovieName    TicketScreenName
          TicketSeatNumber   TicketSeatRow
          TicketSeatCategory TicketShowDate
          TicketShowTime
        )
        WITH lt_update
      REPORTED DATA(lt_reported)
      FAILED   DATA(lt_failed).

    READ ENTITIES OF ZI_BOOKING IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls_res IN lt_result
                      ( %tky   = ls_res-%tky
                        %param = ls_res ) ).
  ENDMETHOD.

ENDCLASS.
