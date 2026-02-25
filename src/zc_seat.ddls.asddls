@EndUserText.label: 'Seat Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZC_SEAT
  provider contract transactional_query
  as projection on ZI_SEAT
{
  @EndUserText.label: 'Seat ID'
  key SeatId,

  @EndUserText.label: 'Screen ID'
  ScreenId,

  @EndUserText.label: 'Seat Number'
  SeatNumber,

  @EndUserText.label: 'Seat Row'
  SeatRow,

  @EndUserText.label: 'Seat Category'
  SeatCategory,

  @EndUserText.label: 'Status'
  Status,

  @EndUserText.label: 'Created By'
  CreatedBy,

  @EndUserText.label: 'Created At'
  CreatedAt,

  @EndUserText.label: 'Last Changed By'
  LastChangedBy,

  @EndUserText.label: 'Last Changed At'
  LastChangedAt,

  @EndUserText.label: 'Local Last Changed At'
  LocalLastChangedAt,

  _Screen : redirected to ZC_SCREEN
}
