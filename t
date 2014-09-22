[33mcommit 586bf09b689727c9d1c360209a5d2899db671022[m
Author: Jan Marciniak <j.marciniakqtempotrac.com>
Date:   Mon Sep 8 22:36:29 2014 +0200

    Finish destroy action

[1mdiff --git a/Gemfile b/Gemfile[m
[1mindex 0ed7a3c..6f468db 100644[m
[1m--- a/Gemfile[m
[1m+++ b/Gemfile[m
[36m@@ -4,6 +4,9 @@[m [mruby '2.0.0'[m
 [m
 gem 'rails', '4.0.8'[m
 gem 'bootstrap-sass', '2.3.2.0'[m
[32m+[m[32mgem 'faker', '1.1.2'[m
[32m+[m[32mgem 'will_paginate', '3.0.4'[m
[32m+[m[32mgem 'bootstrap-will_paginate', '0.0.9'[m
 [m
 group :development, :test do[m
   gem 'sqlite3', '1.3.8'[m
[1mdiff --git a/Gemfile.lock b/Gemfile.lock[m
[1mindex 4cdcd6f..ce492bd 100644[m
[1m--- a/Gemfile.lock[m
[1m+++ b/Gemfile.lock[m
[36m@@ -29,6 +29,8 @@[m [mGEM[m
     bcrypt-ruby (3.1.2-x86-mingw32)[m
     bootstrap-sass (2.3.2.0)[m
       sass (~> 3.2)[m
[32m+[m[32m    bootstrap-will_paginate (0.0.9)[m
[32m+[m[32m      will_paginate[m
     builder (3.1.4)[m
     capybara (2.1.0)[m
       mime-types (>= 1.16)[m
[36m@@ -53,6 +55,8 @@[m [mGEM[m
     factory_girl_rails (4.2.0)[m
       factory_girl (~> 4.2.0)[m
       railties (>= 3.0.0)[m
[32m+[m[32m    faker (1.1.2)[m
[32m+[m[32m      i18n (~> 0.5)[m
     ffi (1.9.3-x86-mingw32)[m
     hike (1.2.3)[m
     i18n (0.6.11)[m
[36m@@ -146,6 +150,7 @@[m [mGEM[m
       execjs (>= 0.3.0)[m
       multi_json (~> 1.0, >= 1.0.2)[m
     websocket (1.0.7)[m
[32m+[m[32m    will_paginate (3.0.4)[m
     xpath (2.0.0)[m
       nokogiri (~> 1.3)[m
 [m
[36m@@ -155,9 +160,11 @@[m [mPLATFORMS[m
 DEPENDENCIES[m
   bcrypt-ruby (= 3.1.2)[m
   bootstrap-sass (= 2.3.2.0)[m
[32m+[m[32m  bootstrap-will_paginate (= 0.0.9)[m
   capybara (= 2.1.0)[m
   coffee-rails (= 4.0.1)[m
   factory_girl_rails (= 4.2.0)[m
[32m+[m[32m  faker (= 1.1.2)[m
   jbuilder (= 1.0.2)[m
   jquery-rails (= 3.0.4)[m
   pg (= 0.15.1)[m
[36m@@ -170,3 +177,4 @@[m [mDEPENDENCIES[m
   sqlite3 (= 1.3.8)[m
   turbolinks (= 1.1.1)[m
   uglifier (= 2.1.1)[m
[32m+[m[32m  will_paginate (= 3.0.4)[m
[1mdiff --git a/app/assets/stylesheets/custom.css.scss b/app/assets/stylesheets/custom.css.scss[m
[1mindex eff092d..4341df7 100644[m
[1m--- a/app/assets/stylesheets/custom.css.scss[m
[1m+++ b/app/assets/stylesheets/custom.css.scss[m
[36m@@ -1,4 +1,8 @@[m
 @import "bootstrap";[m
[32m+[m
[32m+[m
[32m+[m
[32m+[m
 $lightGray: #999; /* universal */[m
 html {[m
 	overflow-y: scroll;[m
[36m@@ -161,4 +165,21 @@[m [minput {[m
 .field_with_errors {[m
   @extend .control-group;[m
   @extend .error;[m
[31m-}[m
\ No newline at end of file[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m/* User Index */[m
[32m+[m[32m.users {[m
[32m+[m	[32mlist-style: none;[m
[32m+[m	[32mmargin: 0;[m
[32m+[m
[32m+[m[32mli {[m
[32m+[m	[32moverflow: auto;[m
[32m+[m	[32mpadding: 10px 0;[m
[32m+[m	[32mpadding-left: 15px;[m
[32m+[m	[32mborder-top: 1px solid $grayLighter;[m
[32m+[m	[32m&:last-child {[m
[32m+[m		[32mborder-bottom:  1px solid $grayLighter;[m
[32m+[m	[32m}[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m}[m
[1mdiff --git a/app/controllers/users_controller.rb b/app/controllers/users_controller.rb[m
[1mindex 3ee01c3..a23e4c8 100644[m
[1m--- a/app/controllers/users_controller.rb[m
[1m+++ b/app/controllers/users_controller.rb[m
[36m@@ -1,6 +1,11 @@[m
 class UsersController < ApplicationController[m
[31m-	before_action :signed_in_user, only: [:edit, :update][m
[32m+[m	[32mbefore_action :signed_in_user, only: [:edit, :update, :index, :destroy][m
 	before_action :correct_user, only: [:edit, :update][m
[32m+[m	[32mbefore_action :admin_user, only: [:destroy][m
[32m+[m
[32m+[m	[32mdef index[m
[32m+[m		[32m@users = User.paginate(page: params[:page])[m
[32m+[m	[32mend[m
 [m
 	def show[m
 		@user = User.find( params[:id] )[m
[36m@@ -35,6 +40,12 @@[m [mclass UsersController < ApplicationController[m
 	  	end	[m
  	end[m
 [m
[32m+[m[41m [m	[32mdef destroy[m
[32m+[m[41m [m		[