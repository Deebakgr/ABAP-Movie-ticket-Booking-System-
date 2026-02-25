@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Screen Interface View'

define root view entity ZI_SCREEN
  as select from zscreen_t
{
  key screen_id            as ScreenId,
      screen_name          as ScreenName,
      total_seats          as TotalSeats,
      screen_type          as ScreenType,
      location             as Location,
      status               as Status,
      created_by           as CreatedBy,
      created_at           as CreatedAt,
      last_changed_by      as LastChangedBy,
      last_changed_at      as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
