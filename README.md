# sharpstones_captcha

This is a very simple ("programming with sharp stones") plugin to do CAPTCHA verification without a ton of JavaScripts or complexity. If you need something quick - especially for a prototype site - and don't want to get bogged down with something complex, this should help. That said, it's probably solid enough for most consumer grade deployments.

Bassically it presents the user with a question of adding the number of the month and the day in a field, and if the total is correct, then the test passes and you can process the rest of the form. The date is presented as "Today is the 12th of February" so someone would need to parse that back to integers if they wanted to try to bypass this. Which probably isn't worth anyone's time.

The equation being generated is build into a param which gets passed back to the Gem as well. So if someone tries to crack into that it will blow up the result and also fail.

## Usage

Inserting this into a view is pretty easy. There's one call to get the params to put in the form. Then just copy and paste.

_Note that the value passed in to get the data is an encryption key. The default to use is the one standard to Rails, but I left this open so that you can use something else if you prefer._

```
# In your view:

<% ssc_data = SharpstoneCaptcha.data_for_form(Rails.application.secrets.secret_key_base) %>
<%= hidden_field_tag :date_captcha_id, ssc_data[:date_captcha_id] %>
<%= text_field_tag :date_captcha_answer, "", :placeholder => "ssc_data[:date_captcha_string] %>
```

```
# In your controller:

if !SharpstoneCaptcha.verify_data_captcha(params, Rails.application.secrets.secret_key_base)
    flash[:error] = "Sentient Being Test Failed!"
else
    # Do something useful ...
    end
``

