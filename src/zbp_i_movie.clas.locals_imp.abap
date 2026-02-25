CLASS lhc_movie DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateMovieName FOR VALIDATE ON SAVE
      IMPORTING keys FOR Movie~validateMovieName.

    METHODS validateReleaseDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Movie~validateReleaseDate.

    METHODS setDefaultStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Movie~setDefaultStatus.

    METHODS cancelMovie FOR MODIFY
      IMPORTING keys FOR ACTION Movie~cancelMovie
      RESULT result.

    METHODS activateMovie FOR MODIFY
      IMPORTING keys FOR ACTION Movie~activateMovie
      RESULT result.
   METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
  IMPORTING REQUEST requested_authorizations FOR Movie
  RESULT result.

ENDCLASS.

CLASS lhc_movie IMPLEMENTATION.

  METHOD validateMovieName.
    READ ENTITIES OF ZI_MOVIE IN LOCAL MODE
      ENTITY Movie
        FIELDS ( MovieName )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_movies).

    LOOP AT lt_movies INTO DATA(ls_movie).
      IF ls_movie-MovieName IS INITIAL.
        APPEND VALUE #(
          %tky = ls_movie-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Movie Name cannot be blank!' )
        ) TO reported-movie.
        APPEND VALUE #( %tky = ls_movie-%tky ) TO failed-movie.

      ELSEIF strlen( ls_movie-MovieName ) < 2.
        APPEND VALUE #(
          %tky = ls_movie-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Movie Name must be at least 2 characters!' )
        ) TO reported-movie.
        APPEND VALUE #( %tky = ls_movie-%tky ) TO failed-movie.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateReleaseDate.
    READ ENTITIES OF ZI_MOVIE IN LOCAL MODE
      ENTITY Movie
        FIELDS ( ReleaseDate )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_movies).

    LOOP AT lt_movies INTO DATA(ls_movie).
      IF ls_movie-ReleaseDate IS INITIAL.
        APPEND VALUE #(
          %tky = ls_movie-%tky
          %msg = new_message_with_text(
                   severity = if_abap_behv_message=>severity-error
                   text     = 'Release Date cannot be blank!' )
        ) TO reported-movie.
        APPEND VALUE #( %tky = ls_movie-%tky ) TO failed-movie.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD setDefaultStatus.
    READ ENTITIES OF ZI_MOVIE IN LOCAL MODE
      ENTITY Movie
        FIELDS ( Status )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_movies).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_MOVIE\\Movie.

    LOOP AT lt_movies INTO DATA(ls_movie).
      IF ls_movie-Status IS INITIAL.
        APPEND VALUE #(
          %tky   = ls_movie-%tky
          Status = 'ACTIVE'
        ) TO lt_update.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MOVIE IN LOCAL MODE
      ENTITY Movie
        UPDATE FIELDS ( Status )
        WITH lt_update
      REPORTED DATA(lt_reported).
  ENDMETHOD.

  METHOD cancelMovie.
    READ ENTITIES OF ZI_MOVIE IN LOCAL MODE
      ENTITY Movie
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_movies).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_MOVIE\\Movie.

    LOOP AT lt_movies INTO DATA(ls_movie).
      APPEND VALUE #(
        %tky   = ls_movie-%tky
        Status = 'CANCELLED'
      ) TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MOVIE IN LOCAL MODE
      ENTITY Movie
        UPDATE FIELDS ( Status )
        WITH lt_update
      REPORTED DATA(lt_reported)
      FAILED   DATA(lt_failed).

    READ ENTITIES OF ZI_MOVIE IN LOCAL MODE
      ENTITY Movie
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result).

    result = VALUE #( FOR ls_res IN lt_result
                      ( %tky   = ls_res-%tky
                        %param = ls_res ) ).
  ENDMETHOD.

  METHOD activateMovie.
    READ ENTITIES OF ZI_MOVIE IN LOCAL MODE
      ENTITY Movie
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_movies).

    DATA lt_update TYPE TABLE FOR UPDATE ZI_MOVIE\\Movie.

    LOOP AT lt_movies INTO DATA(ls_movie).
      APPEND VALUE #(
        %tky   = ls_movie-%tky
        Status = 'ACTIVE'
      ) TO lt_update.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MOVIE IN LOCAL MODE
      ENTITY Movie
        UPDATE FIELDS ( Status )
        WITH lt_update
      REPORTED DATA(lt_reported)
      FAILED   DATA(lt_failed).

    READ ENTITIES OF ZI_MOVIE IN LOCAL MODE
      ENTITY Movie
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
