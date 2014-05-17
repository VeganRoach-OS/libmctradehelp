using Xml;

public errordomain FileError
{
    NOT_FOUND,
    EMPTY
}

public errordomain ReadError
{
    NO_VERSION
}

/**
 * Discovers and handles data from a properly formatted MCTradeHelp XML sheet.
 */
namespace MCTH
{
    /**
     * Controls whether actions are printed to stdout.
     * Defaults to false.
     */
    public bool verbose = false;
    /** 
     * Contains the list of items as string data which must be initialized
     * with init_names().
     */
    public GLib.List<string> names;
    /** Contains the two MCTradeHelp documents. */
    public Xml.Doc* lists[2];

    /**
     * Initializes the lists for further use and does basic sanity checking.
     * @throws FileError Thrown when the file is not found or is empty.
     */
    public void init_lists() throws FileError
    {
        if (verbose) stdout.printf("Initializing XML... ");

        lists[0] = Parser.parse_file("lists/mats.xml");
        lists[1] = Parser.parse_file("lists/recipes.xml");

        foreach (Xml.Doc* d in lists)
        {
            if (d == null)
            {
                throw new FileError.NOT_FOUND("Could not find all lists.");
            }
        }

        foreach (Xml.Doc* d in lists)
        {
            Xml.Node* root = d->get_root_element();
            if (root == null)
            {
                throw new FileError.EMPTY("A list contains no data.");
            }
        }

        if (verbose) stdout.printf("done.\n");
    }

    /**
     * Adds the names of the items to the names array.
     */
    public void init_names()
    {
        for (Xml.Node* n = lists[1]->string_get_node_list("item");
                 n != null; n->next)
        {
            names.append(n->get_prop("id"));
        }
    }

    /**
     * Calculates the price of a given item.
     * @param item The name of the item for which to find the price.
     * @param indent The number of tabs to indent logs (if verbose).
     * @return The price of the item as an arbitrary value for comparison.
     */
    public double get_price(string item, int indent)
    {
        return 0;
    }

    /**
     * Calculates the suggested rate of exchange between two items.
     * @param item1 The initial item.
     * @param item2 The translation item.
     * @param quantity The quantity of item1 traded for some amount of item2.
     * @return The exchange rate between the two items given their prices.
     */
    public double get_exchange_rate(string item1,
                             string item2,
                             int quantity)
    {
        return ( get_price(item1,0) * quantity ) / ( get_price(item2,0) );
    }

    /**
     * Gets the versions of the two XML sheets for debug reference.
     * @return Version of mats.xml and then recipes.xml divided by a new line.
     */
    public string get_xml_versions()
    {
        string s = "";

        try
        {
            s = "mats.xml version " +
                get_mats_version() +
                "\nrecipes.xml version " +
                get_recipes_version();
        } catch (ReadError e) {
            stderr.printf("Error: %s\n", e.message);
        }

        return s;
    }

    /**
     * Gets the version of mats.xml.
     * @return Version of mats.xml as a string.
     * @throws ReadError Thrown if version attribute is not found.
     */
    public string get_mats_version() throws ReadError
    {
        var root = lists[0]->get_root_element();
        for (Xml.Attr* prop = root->properties; prop != null; prop->next)
        {
            if (prop->name == "version")
                return prop->children->content;
        }
        throw new ReadError.NO_VERSION("mats.xml version not found!");
    }

    /**
     * Gets the version of recipes.xml.
     * @return Version of recipes.xml as a string.
     * @throws ReadError Thrown if version attribute is not found.
     */
    public string get_recipes_version() throws ReadError
    {
        var root = lists[1]->get_root_element();
        for (Xml.Attr* prop = root->properties; prop != null; prop->next)
        {
            if (prop->name == "version")
                return prop->children->content;
        }
        throw new ReadError.NO_VERSION("recipes.xml version not found!");
    }
}
