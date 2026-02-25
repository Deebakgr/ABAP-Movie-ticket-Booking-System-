CLASS lhc_seat DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setDefaultStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Seat~setDefaultStatus.
   METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
  IMPORTING REQUEST requested_authorizations FOR Seat
  RESULT result.

ENDCLASS.

CLASS lhc_seat IMPLEMENTATION.

  METHOD setDefaultStatus.
    READ ENTITIES OF ZI_SEAT IN LOCAL MODE
      ENTITY Seat
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_seats).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_SEAT\\Seat.

    LOOP AT lt_seats INTO DATA(ls_seat).
      IF ls_seat-Status IS INITIAL.
        APPEND VALUE #(
          %tky   = ls_seat-%tky
          Status = 'AVAILABLE'
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_SEAT IN LOCAL MODE
      ENTITY Seat
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
