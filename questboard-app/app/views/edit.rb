<!-- PROFILE PAGE -->

<% if flash[:warning] && flash[:warning].count > 0 %>
    <div class="warning"><%= safe_join(flash[:warning], "<br>".html_safe) %></div>
    <br><br><br>
<% end %>
<!-- <div>
    <ul class="navbar-links">
        <li style="float: left">
            <%= link_to "About", root_path, class: "navbar-link" %>
        </li>
        <li style="float: left">
            <%= link_to "Reset Password", "/blog", class: "navbar-link" %>
        </li>
    </ul>
    <br><br>
</div> -->
<div style="height: auto;overflow: auto;">
    <div class="member-photo">
        <% if @member.photo.blank? %>
            <p style="color:white">No Image</p>
        <% else %>
            <img src=<%= "#{@member.photo}"%> width="100%" height="100%" style"border-radius: 100%;-moz-border-radius: 100%;-khtml-border-radius: 100%;-webkit-border-radius: 100%;">
        <% end %>
    </div>
    <%= form_for :user, url: "/users/edit/#{@member.id}" do |f| %>
        <div style="float: right;width:80%;hidden">
            <%= f.text_field :name, :value => @member.name, class: "login-input", placeholder: "Enter your name", style: "margin-top: 1em; width: 60%;" %>
            <%= f.text_field :email, :value => @member.email, class: "login-input", placeholder: "Enter your email", style: "margin-top: 1em; width: 60%;" %>
            <%= f.text_field :photo, class: "login-input", placeholder: "Link your profile photo", style: "margin-top: 1em; width: 60%;" %>
           <br>
            <%= f.file_field :photo %>
            <br><br>
            <% if @member.is_admin %>
                <br><br>
                <%= f.text_area :about, :value => @member.about, class: "signature-textarea", placeholder: "Enter information about yourself"  %>
                <br><br>
            <% end %>
            <%= f.text_area :signature, :value => @member.signature, class: "signature-textarea", placeholder: "Enter your signature"  %>
            <br><br>
            <%= f.submit "Save", class: "login-button", style: "width: 60%" %>
            <br><br>
        </div>
    <% end %>
</div>