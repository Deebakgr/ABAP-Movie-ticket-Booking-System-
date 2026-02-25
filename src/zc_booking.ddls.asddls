@EndUserText.label: 'Booking Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_BOOKING
  provider contract transactional_query
  as projection on ZI_BOOKING
{
  @EndUserText.label: 'Booking ID'
  key BookingId,

  @EndUserText.label: 'Show ID'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_SHOW', element: 'ShowId' } }] 
  ShowId,

  @EndUserText.label: 'Movie ID'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_MOVIE', element: 'MovieId' } }] 
  MovieId,

  @EndUserText.label: 'Screen ID'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_SCREEN', element: 'ScreenId' } }] 
  ScreenId,

  @EndUserText.label: 'Seat ID'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZC_SEAT', element: 'SeatId' } }] 
  SeatId,

  @EndUserText.label: 'Customer Name'
  CustomerName,

  @EndUserText.label: 'Customer Email'
  CustomerEmail,

  @EndUserText.label: 'Customer Phone'
  CustomerPhone,

  @EndUserText.label: 'No of Tickets'
  NoOfTickets,

  @EndUserText.label: 'Total Amount'
  TotalAmount,

  @EndUserText.label: 'Booking Date'
  BookingDate,

  @EndUserText.label: 'Booking Status'
  BookingStatus,

  @EndUserText.label: 'Payment Status'
  PaymentStatus,

  @EndUserText.label: 'Payment Mode'
  PaymentMode,
  
  @EndUserText.label: 'Ticket Number'
  TicketNumber,

  @EndUserText.label: 'Ticket Generated'
  TicketGenerated,
  
  @EndUserText.label: 'Movie Name'   
   TicketMovieName,
   
  @EndUserText.label: 'Screen Name' 
    TicketScreenName,
    
  @EndUserText.label: 'Seat Number'  
   TicketSeatNumber,
   
  @EndUserText.label: 'Seat Row'  
      TicketSeatRow,
      
  @EndUserText.label: 'Seat Category' 
  TicketSeatCategory,
  
  @EndUserText.label: 'Show Date'   
    TicketShowDate,
    
  @EndUserText.label: 'Show Time'    
   TicketShowTime,

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

  _Show   : redirected to ZC_SHOW,
  _Movie  : redirected to ZC_MOVIE,
  _Screen : redirected to ZC_SCREEN,
  _Seat   : redirected to ZC_SEAT
}
