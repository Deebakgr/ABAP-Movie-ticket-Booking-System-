CLASS lhc_screen DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateTotalSeats FOR VALIDATE ON SAVE
      IMPORTING keys FOR Screen~validateTotalSeats.

    METHODS setDefaultStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Screen~setDefaultStatus.
   METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
  IMPORTING REQUEST requested_authorizations FOR Screen
  RESULT result.

ENDCLASS.

CLASS lhc_screen IMPLEMENTATION.

  METHOD validateTotalSeats.
    READ ENTITIES OF ZI_SCREEN IN LOCAL MODE
      ENTITY Screen
        FIELDS ( TotalSeats )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_screens).

    LOOP AT lt_screens INTO DATA(ls_screen).
      IF ls_screen-TotalSeats <= 0.
        APPEND VALUE #(
          %tky = ls_screen-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Total Seats must be greater than zero!' )
        ) TO reported-screen.
        APPEND VALUE #( %tky = ls_screen-%tky ) TO failed-screen.

      ELSEIF ls_screen-TotalSeats > 500.
        APPEND VALUE #(
          %tky = ls_screen-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-warning
                   text     = 'Warning: Seat count exceeds 500!' )
        ) TO reported-screen.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD setDefaultStatus.
    READ ENTITIES OF ZI_SCREEN IN LOCAL MODE
      ENTITY Screen
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_screens).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_SCREEN\\Screen.

    LOOP AT lt_screens INTO DATA(ls_screen).
      IF ls_screen-Status IS INITIAL.
        APPEND VALUE #(
          %tky   = ls_screen-%tky
          Status = 'ACTIVE'
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_SCREEN IN LOCAL MODE
      ENTITY Screen
        UPDATE FIELDS ( Status )
        WITH lt_update
      REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD get_global_authorizations.
  result-%create = if_abap_behv=>auth-allowed.
  result-%update = if_abap_behv=>auth-allowed.
  result-%delete = if_abap_behv=>auth-allowed.
  ENDMETHOD.

ENDCLASS.
