/**
 * TODO: Migrate to new JavaScript testing solution
 * These tests were written using the BlueRidge JS testing plugin for Rails that was
 * abandoned in 2009. I'm leaving them here to help with migrating to a new testing framework
 * when the time comes - I suggest when we make any changes to tag functionality. [Alon]
 */
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
            var event_data;
            before(function()
            {
               $(".tags_control").bind('delete', function(event, data)
               {
                   event_data = data;
               });
           });

           after(function()
           {
              event_data = null; 
           });

           it("should dispatch delete event", function()
           {
               $('.tags_control .edit a.delete:first').trigger('click');
               expect(event_data).to_not(be_null);
               expect(event_data.url).to(equal, '/sfbk/people/602306942/taggings/key%20holder');
           });
        });

        describe("adds tag", function()
        {
            var event_data;
            before(function()
            {
               $(".tags_control").bind('add', function(event, data)
               {
                   event_data = data;
               });
           });

           after(function()
           {
              event_data = null;
           });

           it("should dispatch add event", function()
           {
               $('.tags_control select').val('two').trigger('change');
               expect(event_data).to_not(be_null);
               expect(event_data.url).to(equal, '/sfbk/people/602306942/taggings');
               expect(event_data.tag).to(equal, 'two');
           });

           it("should add new tag", function()
           {
               mock(window).should_receive('prompt').and_return('new');
               $('.tags_control select')[0].selectedIndex = 4;
               $('.tags_control select').trigger('change');
               expect(event_data.url).to(equal, '/sfbk/people/602306942/taggings');
               expect(event_data.tag).to(equal, 'new');

               Smoke.checkExpectations();
           });

           it("should not add empty new tag", function()
           {
               mock(window).should_receive('prompt').and_return('');
               $('.tags_control select')[0].selectedIndex = 4;
               $('.tags_control select').trigger('change');
               expect(event_data).to(be_null);
               expect($('.tags_control select')[0].selectedIndex).to(equal, 0);

               Smoke.checkExpectations();
           });

        });
    });
});
