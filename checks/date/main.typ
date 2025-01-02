#let UNIX_EPOCH = datetime(
  year: 1980,
  month: 1,
  day: 1,
)
#assert.ne(
  datetime.today(),
  UNIX_EPOCH,
)
