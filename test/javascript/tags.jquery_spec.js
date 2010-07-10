require("spec_helper.js");
require("../../public/javascripts/tags.jquery.js");

Screw.Unit(function()
{
    describe("Tags control", function()
    {
        before(function()
        {
            $('#fixture').fixture();
            $('.tags_control').tags_control();
        });

        describe("initializes view", function()
        {
            it("hides edit view", function()
            {
                expect($(".tags_control .edit").is(":visible")).to(be_false);
            });

            it("shows edit", function()
            {
                $('a.show_edit').trigger('click');
                expect($(".tags_control .view").is(":visible")).to(be_false);
                expect($(".tags_control .edit").is(":visible")).to(be_true);
            });
        });

        describe("initializes edit", function()
        {
            it("shows view", function()
            {
                $(".tags_control .view").hide();
                $(".tags_control .edit").show();
                
                $('a.show_view').trigger('click');
                expect($(".tags_control .view").is(":visible")).to(be_true);
                expect($(".tags_control .edit").is(":visible")).to(be_false);
            });

        });

        describe("deletes tag", function()
        {
           it("should dispatch delete event", function()
           {
               var event_data;
               $(".tags_control").bind('delete', function(event, data)
               {
                   event_data = data;
               });

               $('.tags_control .edit a.delete:first').trigger('click');
               expect(event_data).to_not(be_null);
               expect(event_data.url).to(equal, '/sfbk/people/602306942/taggings/key%20holder');
           });
        });

        describe("adds tag", function()
        {
           it("should dispatch add event", function()
           {
               var event_data;
               $(".tags_control").bind('add', function(event, data)
               {
                   event_data = data;
               });

               $('.tags_control select').val('two').trigger('change');
               expect(event_data).to_not(be_null);
               expect(event_data.url).to(equal, '/sfbk/people/602306942/taggings');
               expect(event_data.tag).to(equal, 'two');
           });

        });
    });
});
