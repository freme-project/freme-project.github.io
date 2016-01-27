$(document).ready(function(){
    //Calling GET /e-entity/freme-ner/datasets does not return datasets ordered by Name. This function returns the right index for the .after() function below
    var insort =function (id) {
        for (var i=id-1;i>=0;i--) {
            if ($("#dataseth"+i).length) {
                return i;
            }
        }
        return 0;
    };

    $.ajax({
        url: fremeApiUrl+ "/e-entity/freme-ner/datasets",
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        },
        method: 'GET',
        success: function (data) {
            $(data).each(
                function (i, dataset) {
                    //Ternary operator to add any Description to datasets without description in the database
                    (dataset.Description == "") ? description = "This is dataset \" " + dataset.Name + "\" and it has no description in the database" : description = dataset.Description;
                    var index = insort(dataset.Name);
                    //Adds a datasetOuter div containing a datasetInner div for each dataset with all available information
                    $('#datasetdiv' + index).after(
                        "<h3 id=\"dataseth" + dataset.Name + "\">" + dataset.Name + "</h3>" +
                        "<div id=\"datasetdiv"+dataset.Name+"\">"+
                            "<h4> Description: </h4>"+
                            "<div>"+ description + "</div>"+
                            "<h4> Total Entities: </h4>" +
                            "<div>"+dataset.TotalEntities+"</div>" +
                        "</div>")


                });

            $("#dataseth0 ").remove();
            $("#datasetdiv0").remove();

            $("#datasets").accordion();
        }
    });
});
