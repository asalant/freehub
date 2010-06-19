require("spec_helper.js");
require("../../public/javascripts/tags.jquery.js");

Screw.Unit(function()
{
    describe("Tags plugin", function()
    {
        before(function()
        {
            $('#fixture').fixture();
            $('.tags_control').tags_control();
        });

        describe("view initialization", function()
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

        describe("edit initialization", function()
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
    });
});
