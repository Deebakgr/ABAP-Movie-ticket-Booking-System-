@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Seat Interface View'

define root view entity ZI_SEAT
  as select from zseat_t
  association [0..1] to ZI_SCREEN as _Screen
    on $projection.ScreenId = _Screen.ScreenId
{
  key seat_id              as SeatId,
      screen_id            as ScreenId,
      seat_number          as SeatNumber,
      seat_row             as SeatRow,
      seat_category        as SeatCategory,
      status               as Status,
      created_by           as CreatedBy,
      created_at           as CreatedAt,
      last_changed_by      as LastChangedBy,
      last_changed_at      as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,
      _Screen
}
