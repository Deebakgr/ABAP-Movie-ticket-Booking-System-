@EndUserText.label: 'Show Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZC_SHOW
  provider contract transactional_query
  as projection on ZI_SHOW
{
  @EndUserText.label: 'Show ID'
  key ShowId,

  @EndUserText.label: 'Movie ID'
  MovieId,

  @EndUserText.label: 'Screen ID'
  ScreenId,

  @EndUserText.label: 'Show Date'
  ShowDate,

  @EndUserText.label: 'Show Time'
  ShowTime,

  @EndUserText.label: 'Ticket Price'
  TicketPrice,

  @EndUserText.label: 'Available Seats'
  AvailableSeats,

  @EndUserText.label: 'Total Seats'
  TotalSeats,

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

  _Movie  : redirected to ZC_MOVIE,
  _Screen : redirected to ZC_SCREEN
}
