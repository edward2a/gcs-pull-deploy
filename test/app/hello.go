/*
 * Original code taken from https://gowebexamples.com/hello-world/
 */


package main

import (
  "fmt"
  "net/http"
  "log"
)

func main() {
  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, you've requested: %s\n", r.URL.Path)
    log.Printf("URL Requested: %s\n", r.URL.Path)
  })

  err := http.ListenAndServe(":80", nil)
  if (err != nil) { log.Fatalln(err) }
}
