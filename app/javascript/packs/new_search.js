import "hello_angular/polyfills";
import { Component, NgModule               } from "@angular/core";
import { BrowserModule          } from "@angular/platform-browser";
import { FormsModule            } from "@angular/forms";
import { platformBrowserDynamic } from "@angular/platform-browser-dynamic";
import { Http,HttpModule        } from "@angular/http";
import { RouterModule           } from "@angular/router";

import { NewSearchComponent     } from "NewSearchComponent";
import { SongDetailsComponent   } from "SongDetailsComponent";

var AppComponent = Component({
  selector: "asft-search-app",
  template: "<router-outlet></router-outlet>"
}).Class({
  constructor: [
    function() {}
  ]
});

var routing = RouterModule.forRoot(
  [
    {
      path: "",
      component: NewSearchComponent
    },
    {
      path: ":id",
      component: SongDetailsComponent
    }
  ]
);

var NewAppModule = NgModule({
  imports:      [ BrowserModule, FormsModule, HttpModule, routing ],
  declarations: [ NewSearchComponent, SongDetailsComponent, AppComponent ],
  bootstrap:    [ AppComponent ]
})
.Class({
  constructor: function() {}
});

platformBrowserDynamic().bootstrapModule(NewAppModule);
