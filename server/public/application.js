function swap(name) {
    $.getJSON('/'+name, {}, function(d){
        $('#primary').html(name);
        $('#related').empty();
        for(x in d){
            $('#related').append('<li><a href="#'+d[x].ingredient+'">' + 
                d[x].ingredient + '</a></li>');
        }
    });
}

$(function(){
    
    $('a').live('click', function(){
        swap($(this).html());
    });
    
    swap('egg');
});