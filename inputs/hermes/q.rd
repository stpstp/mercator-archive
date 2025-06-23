<!-- A template for a simple DaCHS cone search service metadata;
To fill it out, search and replace %.*%

Note that this doesn't expose all features of DaCHS.  For advanced
projects, you'll still have to read documentation... -->


<resource schema="hermes" resdir=".">
  <meta name="creationDate">2025-06-13T11:19:30Z</meta>

  <meta name="title">HERMES Data Archive</meta>
  <meta name="description"> A test collection of HERMES spectra
  </meta>
  <!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
  <meta name="subject">%keywords; repeat the element as needed%</meta>

  <meta name="creator">%authors in the format Last, F.I; Next, A.%</meta>
  <meta name="instrument">HERMES ()</meta>
  <meta name="facility">Mercator Telescope</meta>

  <meta name="source">%ideally, a bibcode%</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Catalog</meta>  <!-- or Archive, Survey, Simulation -->

  <!-- Waveband is of Radio, Millimeter,
      Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated -->
  <meta name="coverage.waveband">Optical</meta>

  <table id="main" onDisk="True" mixin="//scs#q3cindex" adql="True">
    <!-- if you don't have a unique identifier, create one; SCS requires
      that no two rows have the same id -->
    <primary>id</primary>

    <!-- Add more STC information as appropriate.  For instance:
      Position ICRS Epoch J2015.0 "ra" "dec" Error "ra_error" "dec_error"

      See also http://docs.g-vo.org/DaCHS/tutorial.html#stc
    -->
    <stc>
      Position ICRS "ra" "dec"
    </stc>

    <!-- id is mandatory for SCS; you can use a different type if you
      want, DaCHS will turn it into string on output (as required by
      by SCS -->
    <column name="id" type="integer"
      ucd="meta.id;meta.main"
      tablehead="Id"
      description="Main identifier for this object."
      verbLevel="1"/>
    <column name="ra" type="double precision"
      unit="deg" ucd="pos.eq.ra;meta.main"
      tablehead="RA"
      description="ICRS right ascension for this object.
        %add more info, like epoch and such%"
      verbLevel="1"/>
    <column name="dec" type="double precision"
      unit="deg" ucd="pos.eq.dec;meta.main"
      tablehead="Dec"
      description="ICRS declination for this object.
        %add more info, like epoch and such%"
      verbLevel="1"/>
    %add further columns%
  </table>

  <coverage>
    <updater sourceTable="main"/>
  </coverage>

  <data id="import">
    <sources pattern="%resdir-relative pattern, like data/*.txt%"/>

    <!-- the grammar really depends on your input material.  See
      http://docs.g-vo.org/DaCHS/ref.html#grammars-available,
      in particular columnGrammar, csvGrammar, fitsTableGrammar,
      and reGrammar; if nothing else helps see embeddedGrammar
      or customGrammar -->
    <csvGrammar names="identifier ra dec mag"/>

    <make table="main">
      <rowmaker idmaps="*">
        <!-- the following example assumes you'll have to
        cut off the first two chars from what's in the source
        to get the identifier for your table -->
        <map dest="id">int(@identifier[2:])</map>
      </rowmaker>
    </make>
  </data>

  <service id="cone" allowed="form,scs.xml">
    <meta name="shortName">%max. 16 characters%</meta>
    <meta name="testQuery">
      <meta name="ra">%an RA of a position returning at least 1 object%</meta>
      <meta name="dec">%a Dec of a position returning at least 1 object%</meta>
      <meta name="sr">%search radius that returns at least 1 object%</meta>
    </meta>

    <!-- the browser interface goes to the VO and the front page -->
    <publish render="form" sets="ivo_managed, local"/>
    <!-- the SCS service isn't usable with a browser, so it goes to
      the VO only -->
    <publish render="scs.xml" sets="ivo_managed"/>
    <!-- all publish elements only become active after you run
      dachs pub q -->

    <scsCore queriedTable="main">
      <FEED source="//scs#coreDescs"/>
      <!-- to enable other query parameters, something like
        <condDesc buildFrom="colname"/> should usually be enough. -->
    </scsCore>
  </service>

  <regSuite title="hermes regression">
    <regTest title="hermes SCS serves some data">
      <url RA="%ra that returns exactly one row%"
          DEC="%dec that returns exactly one row%" SR="0.001"
        >cone/scs.xml</url>
      <code>
        # The actual assertions are pyUnit-like.  Obviously, you want to
        # remove the print statement once you've worked out what to test
        # against.
        row = self.getFirstVOTableRow()
        print(row)
        self.assertAlmostEqual(row["ra"], 22.22222)
      </code>
    </regTest>

    <!-- add more tests: extra tests for the web side, custom widgets,
      rendered outputFields... -->
  </regSuite>
</resource>
