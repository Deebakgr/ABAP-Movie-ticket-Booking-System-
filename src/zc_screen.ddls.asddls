@EndUserText.label: 'Screen Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZC_SCREEN
  provider contract transactional_query
  as projection on ZI_SCREEN
{
  @EndUserText.label: 'Screen ID'
  key ScreenId,

  @EndUserText.label: 'Screen Name'
  ScreenName,

  @EndUserText.label: 'Total Seats'
  TotalSeats,

  @EndUserText.label: 'Screen Type'
  ScreenType,

  @EndUserText.label: 'Location'
  Location,

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
  LocalLastChangedAt
}
