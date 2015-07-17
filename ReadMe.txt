Instructions: You have 4 hours to complete the assignment. In your email, you can also explain what you would have done differently if you were given more time. Your assignment is to write an executable app, which uses one of the well known APIs, i.e..

http://api.eniro.com or

https://foursquare.com/

Please display pizza restaurants close to the user position (5 closest restaurants suffice, use the included New_York_Trip.gpx file to simulate location). The resulting list should at least show the restaurant name and be sorted in an ascending order using the value “name”.

    Please list them on a UITableView with your own subclass of UITableViewCell, load the design for a cell from a XIB file.

    You are free to use any method you want in order to achieve this, i.e. treat the assignment as you would any other project.

    Create UIViewController with details of a single PizzaPlace.

    Please make a transition to the newly created view controller if user click on a cell. Display there some detailed information passed from the controller with UITableView.

    Please create a Core Data model with PizzaPlace entity and fill it with the downloaded data.

    Save it asynchronously and inform all objects interested about that change through NSNotificationCenter.