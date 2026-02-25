@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Interface View'

define root view entity ZI_BOOKING
  as select from zbooking_t
  association [0..1] to ZI_SHOW   as _Show
    on $projection.ShowId   = _Show.ShowId
  association [0..1] to ZI_MOVIE  as _Movie
    on $projection.MovieId  = _Movie.MovieId
  association [0..1] to ZI_SCREEN as _Screen
    on $projection.ScreenId = _Screen.ScreenId
  association [0..1] to ZI_SEAT   as _Seat
    on $projection.SeatId   = _Seat.SeatId
{
  key booking_id              as BookingId,
      show_id                 as ShowId,
      movie_id                as MovieId,
      screen_id               as ScreenId,
      seat_id                 as SeatId,
      customer_name           as CustomerName,
      customer_email          as CustomerEmail,
      customer_phone          as CustomerPhone,
      no_of_tickets           as NoOfTickets,
      total_amount            as TotalAmount,
      booking_date            as BookingDate,
      booking_status          as BookingStatus,
      payment_status          as PaymentStatus,
      payment_mode            as PaymentMode,
      ticket_number           as TicketNumber,
      ticket_generated        as TicketGenerated,
      ticket_movie_name       as TicketMovieName,
      ticket_screen_name      as TicketScreenName,
      ticket_seat_number      as TicketSeatNumber,
      ticket_seat_row         as TicketSeatRow,
      ticket_seat_category    as TicketSeatCategory,
      ticket_show_date        as TicketShowDate,
      ticket_show_time        as TicketShowTime,
      created_by              as CreatedBy,
      created_at              as CreatedAt,
      last_changed_by         as LastChangedBy,
      last_changed_at         as LastChangedAt,
      local_last_changed_at   as LocalLastChangedAt,
      _Show,
      _Movie,
      _Screen,
      _Seat
}
