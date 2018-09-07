# Create Hidden Divs

HTML
----

Call your DIV as you would normal links

````
<a href="#" onclick="show(1)">link 1</a><br>
<a href="#" onclick="show(2)">link 2</a><br>
<a href="#" onclick="show(3)">link 3</a><br>
<a href="#" onclick="show(4)">link 4</a><br>
````

The DIV's must have the id “content_” followed by a number. This number related to the link above.

The **Default**  DIV has no “lay” class. This will be displayed when the page loads.

````
<div id="content_1">
      Div one is the default Content.<br>
      It will be covered by the other 2 links.<br>
  </div>
````

**Hidden/ No Default**

````
<div id="content_2" class="lay" >
      Div 2 Content is Here<br>
      Place What ever you would like!!!
  </div>
  <div id="content_3" class="lay" >
      Div 3 Content is Here<br>
      Place What ever you would like!!!
  </div>
  <div id="content_4" class="lay" >
      Div 4 Content is Here<br>
      Place What ever you would like!!!
  </div>
````

CSS
---

The “lay” class will tell the browser to hide the DIV unless clicked on.

````
<style type="text/css">
  a,a:visited{
    color: #0000FF;
    text-decoration: none;
  }
  a:hover{
    color: #0000FF;
    text-decoration: underline;
  }
  .lay {
  display: none;
  position: relative;
  }
</style>
````

Java
----

You must set the number of hidden fields.

````
<script>
  n = 4; // number of hidden layers
  function show(a){
    for(i=1;i<=n;i++){
      document.getElementById('content_'+i).style.display = 'none';}
    document.getElementById('content_'+a).style.display = 'inline';
  }
</script>
````


