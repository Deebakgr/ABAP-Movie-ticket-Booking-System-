@EndUserText.label: 'Movie Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZC_MOVIE
  provider contract transactional_query
  as projection on ZI_MOVIE
{
  @EndUserText.label: 'Movie ID'
  key MovieId,

  @EndUserText.label: 'Movie Name'
  MovieName,

  @EndUserText.label: 'Genre'
  Genre,

  @EndUserText.label: 'Duration (Mins)'
  DurationMins,

  @EndUserText.label: 'Release Date'
  ReleaseDate,

  @EndUserText.label: 'Language'
  Language,

  @EndUserText.label: 'Rating'
  Rating,

  @EndUserText.label: 'Description'
  Description,

  @EndUserText.label: 'Director'
  Director,

  @EndUserText.label: 'Cast Members'
  CastMembers,

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
