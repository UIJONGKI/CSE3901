# README

Welcome to Team X6's version of the OSU Columbus CSE course catalog and grader assignment system!
To use our program, please be sure to first have Ruby version 3.0.2 installed on a compatible Linux machine, and Rails gem version 6.1.4. Other versions may suffice, but we cannot guarantee their performance.

To get started with our program, open a terminal and begin with the directory where you have extracted our build, then navigate to:
/x6/lab-2

Our program also depends upon a number of Ruby Gems. To install them, inside of this directory, run the command:
bundle install

Afterwards, to begin preparing the database, please run the following commands in order:
rails db:migrate:reset
rails db:seed

These commands will allow you to set up our database of users, courses and sections on your local machine, and automatically populate them with the currently listed CSE courses and sections (see Issue note at the bottom of this document) and a default admin account.
The default admin login credentials are:
Username: 'admin.1@osu.edu'
Password: '123456'

Our program allows users to sign up in order to view the course catalog. Users are divided into three user types: Students, Instructors, and Admins.
All newly registered users are initially assigned the role of Student. However, they may submit a request to be promoted to the role of an Instructor or an Admin, through the "Request Role Change" link on the navigation bar. These requests can be viewed and approved by Admins, from the "Manage User Roles" link exclusive to them on the navigation bar (they do so by manually changing the user type of the given user). Admins are also have the ability to change the user type of any other user at any time (including themselves).

WARNING: We do not recommend changing the user type of an admin user. However, should all admin users accidentally be demoted, we recommend reloading the database entirely using the same following two commands at the terminal:
rails db:migrate:reset
rails db:seed

Users must be signed in to view the course catalog, and all of the defined user types are allowed to view the catalog. Sections pertaining to an individual course can be viewed by visiting their respective course pages opened from the catalog.

Admins possess the exclusive ability to add, edit, and delete individual courses and sections, and can do some from the overall course view, or from individual course or individual section views. From the admin panel, they may also choose to reload the database from OSU's officially uploaded course/section data from https://classes.osu.edu/class-search/#/

All users may also change their email and password by accessing the link containing their currently signed in email address on the navigation bar.
However, for both account editing and creation: all users must register an email account that follows the OSU lastname.# scheme.

Student level accounts have the option to create a grader profile for themselves via the button on the homepage. Here, they will be able to fill out information regarding their completed courses, the courses that they're interested in grading for, a marker indicating whether or not they are interested in grading for the current semester, and their times of availability where they may freely pick up a grading position, in the case that they may be needed to attend the class they're grading for themselves.

Instructors have the ability to write recommendation letters for potential graders, regardless of whether or not that student is registered in the system. These recommendations are linked by OSU email, and should the admins in charge of assigning graders come across a page displaying prospective graders whose emails match some of these recommendations, the admins will be able to handily see them.

Admins, finally, have the ability to assign prospective student graders registered on the site to sections in the database. Admins are able to view grader profiles and instructor recommendations prior to making these assignments.

WARNING: The "Reload Database" button available to admins on the course index page, in addition to wiping out all existing courses and sections saved to the database, will also wipe out all grader assignments to their respective sections. Thus, we recommend only using this feature at the end of any terms where our program was used to facilitate assigning graders to CSE courses.

To shut down our server, simply press Ctrl-C at the terminal that was used to start it.

ISSUE: The API results seem to limit the number of sections it returns relative to the number of courses it returns. This means that our current database does not contain all of the information in the API. We believe that in order to access the full sections list, we would need to run an individual search for each course. We have assumed that this would be outside the scope of our project. 


