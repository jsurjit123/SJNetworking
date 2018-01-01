# SJNetworking

This exercise involves a “proof of concept” app which consumes a REST service and displays photos with headings and descriptions.

1. Its a universal iOS App for both iPhone and iPad. 
2. It ingests a json feed from https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json
3. Uses default JSON parser.
4. The feed contains a title and a list of rows. App displays the content (including image, title and description) in a table
5. The title in the navbar is updated from the json
6. Each row has the right height to display its own content. No content should be clipped. This means some rows will be larger than others.
7. Loads the images lazily. (Doesn't download them all at once, but only as needed)
8. Refresh function removes all previous data and creates new HTTP requests to download JSON and images.
11. App does not block UI when loading the data from the json feed.
12. There is no Storyboard / XIBs used in this project. No autolayout required. 
13. Used NSURLConnection with NSOperationQueue class

Please use the code as required. If you find any bugs/concerns, please mail me at : jsurjit123@gmail.com

Thanks,
Surjit
Happy Coding!!!
