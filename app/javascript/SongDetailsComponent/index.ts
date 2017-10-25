import { Component      } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { Router         } from "@angular/router";
import { Http           } from "@angular/http";
import   template         from "./template.html";

var SongDetailsComponent = Component({
  selector: "asft-song-details",
  template: template
}).Class({
  constructor: [
    ActivatedRoute,
    Http,
    Router,
    function(activatedRoute, http, router) {
      this.activatedRoute = activatedRoute;
      this.http           = http;
      this.id             = null;
      this.song           = null;
      this.router         = router;
    }
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
    self.keywords = $event;
    if (self.keywords.length < 3) {
      return;
    }
    self.http.get(
      "/tags.json?keywords=" + self.keywords
    ).subscribe(
      function(response) {
        self.newtags = response.json().tags;
      }
    );
  },
  addTag: function(tag, song) {
    var self = this;
    self.tag = tag.id;
    self.song = song.id;
    self.category = "content";
    self.http.post(
      "/taggings.json?",
      {tagging: {tag: self.tag,
      song: self.song,
      category: self.category}}
    ).subscribe(
      function(response) {
        self.http.get("/songs/" + song.id + ".json");
      }
    );
  },
  ngOnInit: function() {
    var self = this;
    var observableFailed = function(response) {
      alert(response);
    }
    var songGetSuccess = function(response) {
      self.song = response.json().song;
      self.tags = response.json().tags;
    }
    var routeSuccess = function(params) {
      self.http.get(
        "/songs/" + params["id"] + ".json"
      ).subscribe(
        songGetSuccess,
        observableFailed
      );
    }
    self.activatedRoute.params.subscribe(routeSuccess,observableFailed);
  },
});
export { SongDetailsComponent };
