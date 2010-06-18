require("spec_helper.js");
require("../../public/javascripts/tags.jquery.js");

Screw.Unit(function()
{
    describe("Tags", function()
    {
        before(function()
        {
            $('#fixture').fixture();
            $('.tags').tags_edit();
        });

        it("hides all tags", function()
        {
            expect($(".tags_all").is(":visible")).to(be_false);
        });
    });
});
