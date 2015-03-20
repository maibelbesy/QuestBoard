<!-- PROFILE PAGE -->
<% if logged_in? && @current_user.id == @member.id %>
    <div style="">
        <%= button_to "Edit Profile", user_edit_path(params[:id]), class: "delete-post", style: "float:right;margin-right: 1em;", method: :get %>
    </div>
<% end %>

<div style="height: auto;overflow: auto;">
    <div class="member-photo">
        <% if @member.photo.blank? %>
            <p style="color:white">No Image</p>
        <% else %>
            <img src=<%= "#{@member.photo}"%> width="100%" height="100%" style"border-radius: 100%;-moz-border-radius: 100%;-khtml-border-radius: 100%;-webkit-border-radius: 100%;">
        <% end %>
    </div>

    <div style="float: right;width:80%;">
        <p id="member-name" style="margin-top: 1em;"> <%= "#{@member.name}" %> </p>
        <p id="member-name"> <%= "#{@member.email}" %> </p>
        <p id="member-about" style="margin-top: 4em;"> <%= "#{@member.about}" %> </p>
    </div>
</div>

<% if false %>
    <%= form_for :user,:html => { :multipart => true }, url: "/users/edit/#{@member.id}" do |f| %>
        <div style="float: right;width:80%;">
            <%= f.text_field :name, :value => @member.name, class: "login-input", placeholder: "Enter your name", style: "margin-top: 1em; width: 60%;" %>
            <%= f.text_field :email, :value => @member.email, class: "login-input", placeholder: "Enter your email", style: "margin-top: 1em; width: 60%;" %>
            <%= f.text_field :photo, :value => @member.photo, class: "login-input", placeholder: "Link your profile photo", style: "margin-top: 1em; width: 60%;" %>
            <br>
            <%= image_tag @user.photo.url(:small) %>
            <br><br>
            <% if @member.is_admin %>
                <br><br>
                <%= f.text_area :about, :value => @member.about, class: "signature-textarea", placeholder: "Enter information about yourself"  %>
                <br><br>
            <% end %>
            # <%= f.text_area :signature, :value => @member.signature, class: "signature-textarea", placeholder: "Enter your signature"  %>
            # <br><br>
            <%= f.submit "Save", class: "login-button", style: "width: 60%" %>
            <br><br>
        </div>
    <% end %>
    </div>
<% end %>