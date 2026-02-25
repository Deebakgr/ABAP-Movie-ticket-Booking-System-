CLASS lhc_show DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateShowDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Show~validateShowDate.

    METHODS validateTicketPrice FOR VALIDATE ON SAVE
      IMPORTING keys FOR Show~validateTicketPrice.

    METHODS setAvailableSeats FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Show~setAvailableSeats.

    METHODS setDefaultStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Show~setDefaultStatus.

    METHODS cancelShow FOR MODIFY
      IMPORTING keys FOR ACTION Show~cancelShow
      RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
  IMPORTING REQUEST requested_authorizations FOR Show
  RESULT result.

ENDCLASS.

CLASS lhc_show IMPLEMENTATION.

  METHOD validateShowDate.
    READ ENTITIES OF ZI_SHOW IN LOCAL MODE
      ENTITY Show
        FIELDS ( ShowDate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_shows).

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_shows INTO DATA(ls_show).
      IF ls_show-ShowDate IS INITIAL.
        APPEND VALUE #(
          %tky = ls_show-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Show Date cannot be blank!' )
        ) TO reported-show.
        APPEND VALUE #( %tky = ls_show-%tky ) TO failed-show.

      ELSEIF ls_show-ShowDate < lv_today.
        APPEND VALUE #(
          %tky = ls_show-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Show Date cannot be in the past!' )
        ) TO reported-show.
        APPEND VALUE #( %tky = ls_show-%tky ) TO failed-show.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateTicketPrice.
    READ ENTITIES OF ZI_SHOW IN LOCAL MODE
      ENTITY Show
        FIELDS ( TicketPrice )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_shows).

    LOOP AT lt_shows INTO DATA(ls_show).
      IF ls_show-TicketPrice <= 0.
        APPEND VALUE #(
          %tky = ls_show-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Ticket Price must be greater than zero!' )
        ) TO reported-show.
        APPEND VALUE #( %tky = ls_show-%tky ) TO failed-show.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD setAvailableSeats.
    READ ENTITIES OF ZI_SHOW IN LOCAL MODE
      ENTITY Show
        FIELDS ( ScreenId AvailableSeats TotalSeats )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_shows).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_SHOW\\Show.

    LOOP AT lt_shows INTO DATA(ls_show).
      IF ls_show-AvailableSeats IS INITIAL
      AND ls_show-ScreenId IS NOT INITIAL.

        SELECT SINGLE total_seats
          FROM zscreen_t
          WHERE screen_id = @ls_show-ScreenId
          INTO @DATA(lv_total_seats).

        APPEND VALUE #(
          %tky           = ls_show-%tky
          AvailableSeats = lv_total_seats
          TotalSeats     = lv_total_seats
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_SHOW IN LOCAL MODE
      ENTITY Show
        UPDATE FIELDS ( AvailableSeats TotalSeats )
        WITH lt_update
      REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD setDefaultStatus.
    READ ENTITIES OF ZI_SHOW IN LOCAL MODE
      ENTITY Show
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_shows).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_SHOW\\Show.

    LOOP AT lt_shows INTO DATA(ls_show).
      IF ls_show-Status IS INITIAL.
        APPEND VALUE #(
          %tky   = ls_show-%tky
          Status = 'OPEN'
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_SHOW IN LOCAL MODE
      ENTITY Show
        UPDATE FIELDS ( Status )
        WITH lt_update
      REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD cancelShow.
    READ ENTITIES OF ZI_SHOW IN LOCAL MODE
      ENTITY Show
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_shows).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_SHOW\\Show.

    LOOP AT lt_shows INTO DATA(ls_show).
      APPEND VALUE #(
        %tky   = ls_show-%tky
        Status = 'CANCELLED'
      ) TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_SHOW IN LOCAL MODE
      ENTITY Show
        UPDATE FIELDS ( Status )
        WITH lt_update
      REPORTED DATA(lt_reported)
      FAILED   DATA(lt_failed).

    READ ENTITIES OF ZI_SHOW IN LOCAL MODE
      ENTITY Show
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls_res IN lt_result
                      ( %tky   = ls_res-%tky
                        %param = ls_res ) ).
  ENDMETHOD.

  METHOD get_global_authorizations.
  result-%create = if_abap_behv=>auth-allowed.
  result-%update = if_abap_behv=>auth-allowed.
  result-%delete = if_abap_behv=>auth-allowed.
  ENDMETHOD.

ENDCLASS.
