module URLSearchParams = {
  type urlSearchParams

  @new
  external make: string => urlSearchParams = "URLSearchParams"

  @return(nullable) @bs.send
  external get: (urlSearchParams, string) => option<string> = "get"
}
