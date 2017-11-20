import { Component      } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { Router         } from "@angular/router";
import { Http           } from "@angular/http";
import   template         from "./template.html";
import   * as _           from "lodash";

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

      var that = this;
      this.newTags        = [];

      this.getTags = _.debounce((term, request) => {
        request.get(
          "/tags.json?keywords=" + term
        ).subscribe(
          function(response) {
            that.newTags = response.json().tags;
          }
        );
      }, 762, {'leading': true, 'trailing': true});

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
    if (self.keywords.length < 2) {
      return;
    }

    self.getTags(self.keywords, self.http);

  },
  addTag: function(name) {
    var self = this;
    self.http.post(
      "/tags.json?",
      {tag: {name: name}}
    ).subscribe(
      function(response) {
      self.newTags.unshift(response.json().tag);
      }
    );
  },
  addTagging: function(tag) {
    var self = this;
    self.tag = tag;
    self.category = "tag";
    self.http.post(
      "/taggings.json?",
      {tagging: {tag: self.tag.id,
      song: self.song.id,
      category: self.category}}
    ).subscribe(
      function(response) {
        self.tags.push(response.json().tag);
      }
    );
  },
  upvote: function(tag) {
    var self = this;
    self.tag = tag;

    if (self.upvotedTags.filter(item => item.tag.id !== tag.tag.id).length !== self.upvotedTags.length) {
      return;
    }

    self.http.post(
      "/votes/upvote.json?",
      { tag_id: self.tag.tag.id,
        voteable_type: "Tagging",
        song_id: self.song.id }
    ).subscribe(
      function(response) {
        self.upvotedTags.push(response.json().tag);
        self.downvotedTags = self.downvotedTags.filter(item => item.tag.id !== response.json().tag.tag.id);
        self.unvotedTags = self.unvotedTags.filter(item => item.tag.id !== response.json().tag.tag.id);
      }
    )
  },
  downvote: function(tag) {
    var self = this;
    self.tag = tag;

    if (self.downvotedTags.filter(item => item.tag.id !== tag.tag.id).length !== self.downvotedTags.length) {
      return;
    }

    self.http.post(
      "/votes/downvote.json?",
      {
        tag_id: self.tag.tag.id,
        voteable_type: "Tagging",
        song_id: self.song.id
      },
    ).subscribe(
      function(response) {
        self.downvotedTags.push(response.json().tag);
        self.upvotedTags = self.upvotedTags.filter(item => item.tag.id !== response.json().tag.tag.id);
        self.unvotedTags = self.unvotedTags.filter(item => item.tag.id !== response.json().tag.tag.id);
      }
    )
  },
  ngOnInit: function() {
    var self = this;
    var observableFailed = function(response) {
      alert(response);
    }
    var songGetSuccess = function(response) {
      self.song = response.json().song;
      self.tags = response.json().tags;
      self.upvotedTags = response.json().upvoted_tags;
      self.downvotedTags = response.json().downvoted_tags;
      self.unvotedTags = response.json().unvoted_tags;
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
