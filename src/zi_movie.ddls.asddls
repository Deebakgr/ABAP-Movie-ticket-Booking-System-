@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Movie Interface View'

define root view entity ZI_MOVIE
  as select from zmovie_t
{
  key movie_id             as MovieId,
      movie_name           as MovieName,
      genre                as Genre,
      duration_mins        as DurationMins,
      release_date         as ReleaseDate,
      language             as Language,
      rating               as Rating,
      description          as Description,
      director             as Director,
      cast_members         as CastMembers,
      status               as Status,
      created_by           as CreatedBy,
      created_at           as CreatedAt,
      last_changed_by      as LastChangedBy,
      last_changed_at      as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
