import { Component } from "@angular/core";
import { Http      } from "@angular/http";
import { Router    } from "@angular/router";
import   template    from "./template.html";

import   * as _      from "lodash";

var NewSearchComponent = Component({

  selector: "asft-new-search",
  template: template
}).Class({
  constructor: [
    Http,
    Router,
    function(http, router) {
      this.songs = null;
      this.tags = null;
      this.http      = http;
      this.keywords  = "";
      this.options = ["title ASC", "title DESC", "artist ASC", "artist DESC"];
      this.option = "title ASC";
      this.songOrder = "title ASC";
      this.pages = 0;
      this.page = 0;
      this.router = router;
      var that = this;

      this.getSongs = _.debounce((term, sort, page, request) => {
        request.get(
          "/songs.json?keywords=" + term + "&sort=" + sort + "&page=" + page
        ).subscribe(
          function(response) {
            that.songs = response.json().songs;
            that.songOrder = response.json().sort;
            that.pages = response.json().pages;
            that.page = response.json().page;
          }
        );
      }, 762, {'leading': false, 'trailing': true});

      this.getTags = _.debounce((term, request) => {
        request.get(
          "/tags.json?keywords=" + term
        ).subscribe(
          function(response) {
            that.tags = response.json().tags;
          }
        );
      }, 762, {'leading': false, 'trailing': true});

    },
  ],
  viewDetails: function(element) {
    if (element.name)
      var cont = "tags";
    else if (element.title)
      var cont = "songs";

    this.router.navigate(["/", cont, element.id]);
  },
  search: function($event) {
    var self = this;
    self.page = 0;
    self.keywords = $event;
    if (self.keywords.length < 2) {
      return;
    }

    self.getSongs(self.keywords, self.songOrder, self.page, self.http);
    self.getTags(self.keywords, self.http);

  },
  sort: function($event) {
    var self = this;
    self.page = 0;
    self.songOrder = $event;

    self.getSongs(self.keywords, self.songOrder, self.page, self.http);
  },
  turnPage: function(diff) {
    var self = this;
    self.page = (self.page > 0 || diff > 0) ? self.page + diff : 0;
    console.log("Turning page.");
    console.log(diff);

    self.getSongs(self.keywords, self.songOrder, self.page, self.http);
  }
});

export { NewSearchComponent };
