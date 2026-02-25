@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Show Interface View'

define root view entity ZI_SHOW
  as select from zshow_t
  association [0..1] to ZI_MOVIE  as _Movie
    on $projection.MovieId  = _Movie.MovieId
  association [0..1] to ZI_SCREEN as _Screen
    on $projection.ScreenId = _Screen.ScreenId
{
  key show_id              as ShowId,
      movie_id             as MovieId,
      screen_id            as ScreenId,
      show_date            as ShowDate,
      show_time            as ShowTime,
      ticket_price         as TicketPrice,
      available_seats      as AvailableSeats,
      total_seats          as TotalSeats,
      status               as Status,
      created_by           as CreatedBy,
      created_at           as CreatedAt,
      last_changed_by      as LastChangedBy,
      last_changed_at      as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,
      _Movie,
      _Screen
}
