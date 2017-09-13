import { Component } from "@angular/core";
import { Http      } from "@angular/http";
import   template    from "./template.html";

var SongSearchComponent = Component({

  selector: "asft-song-search",
  template: template
}).Class({
  constructor: [
    Http,
    function(http) {
      this.songs = null;
      this.http      = http;
      this.keywords  = "";
    }
  ],
  search: function($event) {
    var self = this;
    self.keywords = $event;
    if (self.keywords.length < 3) {
      return;
    }
    self.http.get(
      "/songs.json?keywords=" + self.keywords
    ).subscribe(
      function(response) {
        self.songs = response.json().songs;
      },
      function(response) {
        window.alert(response);
      }
    );
  }
});

export { SongSearchComponent };
