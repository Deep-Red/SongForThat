import "hello_angular/polyfills";
import { NgModule               } from "@angular/core";
import { BrowserModule          } from "@angular/platform-browser";
import { FormsModule            } from "@angular/forms";
import { platformBrowserDynamic } from "@angular/platform-browser-dynamic";
import { Http,HttpModule        } from "@angular/http";
import { NewSearchComponent     } from "NewSearchComponent";


var NewAppModule = NgModule({
  imports:      [ BrowserModule, FormsModule, HttpModule ],
  declarations: [ NewSearchComponent ],
  bootstrap:    [ NewSearchComponent ]
})
.Class({
  constructor: function() {}
});

platformBrowserDynamic().bootstrapModule(NewAppModule);
