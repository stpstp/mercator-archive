<resource schema="hermes" resdir=".">
	<meta name="creationDate">2025-06-24T09:45:29Z</meta>

	<meta name="title">HERMES Data Archive</meta>
  <meta name="description"> A test collection of HERMES spectra
  </meta>
  <!-- Take keywords from
    http://www.ivoa.net/rdf/uat
    if at all possible -->
  <meta name="subject">%keywords; repeat the element as needed%</meta>

  <meta name="creator">Prins, S.;Dirickx, M.</meta>
  <meta name="instrument">HERMES ()</meta>
  <meta name="facility">Mercator Telescope</meta>

  <meta name="source">2011A&amp;A...526A..69R</meta>
  <meta name="contentLevel">Research</meta>
  <meta name="type">Catalog</meta>  <!-- or Archive, Survey, Simulation -->

  <!-- Waveband is of Radio, Millimeter,
      Infrared, Optical, UV, EUV, X-ray, Gamma-ray, can be repeated -->
  <meta name="coverage.waveband">Optical</meta>

	<meta name="ssap.dataSource">pointed</meta>
	<meta name="ssap.creationType">archival</meta>

	<!-- in case you serve anything but a spectrum, see
	http://www.ivoa.net/rdf/dataproduct_type
	for what terms you can use here; you can have more than one productType -->
	<meta name="productType">spectrum</meta>
	<meta name="ssap.testQuery">MAXREC=1</meta>

	<table id="raw_data" onDisk="True" adql="hidden"
			namePath="//ssap#instance">
		<!-- the table with your custom metadata; it is transformed
			to something palatable for SSA using the view below -->

		<!-- for an explanation of what columns will be defined in the
		final view, see http://docs.g-vo.org/DaCHS/ref.html#the-ssap-view-mixin.

		Don't mention anything constant here; fill it in in the view
		definition.
		-->
		<LOOP listItems="ssa_dateObs ssa_dstitle ssa_targname ssa_timeExt
			ssa_specstart ssa_specend">
			<events>
				<column original="\item"/>
			</events>
		</LOOP>

		<column name="unique_seqno" type="integer" required="True"
			ucd="meta.id"
			tablehead="Unique Seqno"
			description="The unique sequence number for this observation,
				counting every exposure made with this instrument; this
				remains constant over multiple versions of the same file."/>

		<mixin>//products#table</mixin>
		<mixin>//ssap#plainlocation</mixin>
		<mixin>//ssap#simpleCoverage</mixin>
		<FEED source="//scs#splitPosIndex"
			columns="ssa_location"
			long="degrees(long(ssa_location))"
			lat="degrees(lat(ssa_location))"/>

		<column name="datalink" type="text"
			tablehead="Datalink"
			description="A link to a datalink document for this spectrum."
			verbLevel="15" displayHint="type=url">
			<property name="targetType"
			 >application/x-votable+xml;content=datalink</property>
			<property name="targetTitle">Datalink</property>
		</column>

	</table>

	<data id="import">
		<recreateAfter>make_view</recreateAfter>
		<property key="previewDir">previews</property>
		<sources recurse="True"
			pattern="data/*.fits"/>

		<fitsProdGrammar qnd="True">
			<rowfilter procDef="//products#define">
				<bind key="table">"\schema.raw_data"</bind>
				<bind key="path">\fullDLURL{sdl}</bind>
				<bind key="fsize">2000000</bind>
				<bind key="datalink">"\rdId#sdl"</bind>
				<bind key="mime">"application/x-votable+xml"</bind>
				<bind key="preview">\standardPreviewPath</bind>
				<bind key="preview_mime">"image/png"</bind>
			</rowfilter>
		</fitsProdGrammar>

		<make table="raw_data">
			<rowmaker idmaps="*">
				<var key="specAx">getWCSAxis(@header_, 1)</var>

				<apply procDef="//ssap#fill-plainlocation">
					<bind key="ra">@RA</bind>
					<bind key="dec">@DEC</bind>
					<bind key="aperture">2.5/3600</bind>
				</apply>

				<map key="ssa_dateObs">@BJD-stc.JD_MJD</map>
				<map key="ssa_dstitle">"{} {}".format("HERMES", @OBJECT)</map>
				<map key="ssa_targname">@OBJECT</map>
				<map key="ssa_specstart">math.exp(@specAx.pixToPhys(1))*1e-10</map>
				<map key="ssa_specend"
						>math.exp(@specAx.pixToPhys(@specAx.axisLength))*1e-10</map>
				<map key="ssa_timeExt">@EXPTIME</map>

				<map key="datalink">\dlMetaURI{sdl}</map>

				<map key="unique_seqno">@UNSEQ</map>
			</rowmaker>
		</make>
	</data>

	<table id="data" onDisk="True" adql="True">
			<meta name="_associatedDatalinkService">
			<meta name="serviceId">sdl</meta>
			<meta name="idColumn">ssa_pubDID</meta>
		</meta>

		<mixin
			sourcetable="raw_data"
			copiedcolumns="*"
			ssa_fluxunit="''"
			ssa_spectralunit="'Angstrom'"
			ssa_bandpass="'Optical'"
			ssa_collection="'HERMES'"
			ssa_fluxcalib="'RELATIVE'"
			ssa_fluxucd="'phot.flux.density;em.wl'"
			ssa_speccalib="'ABSOLUTE'"
			ssa_spectralucd="'em.wl'"
			ssa_targclass="'star'"
			ssa_aperture="2.5/3600"
		>//ssap#view</mixin>

<!--		<mixin
			calibLevel="2"
			coverage="ssa_region"
			sResolution="ssa_spaceres"
			oUCD="ssa_fluxucd"
			emUCD="ssa_spectralucd"
			>//obscore#publishSSAPMIXC</mixin> -->
	</table>

	<data id="make_view" auto="False">
		<make table="data"/>
	</data>

	<coverage>
		<updater sourceTable="data"/>
	</coverage>

	<!-- This is the table definition *for a single spectrum* as used
		by datalink.  If you have per-bin errors or whatever else, just
		add columns as above. -->
	<table id="instance" onDisk="False">
		<mixin ssaTable="data"
			spectralDescription="Wavelength"
			fluxDescription="Merged and deblazed flux"
			>//ssap#sdm-instance</mixin>
		<meta name="description">Merged Echelle Orders</meta>
	</table>

	<data id="build_spectrum">
		<embeddedGrammar>
			<iterator>
				<setup imports="gavo.protocols.products,gavo.utils.pyfits"/>
				<code>
					fitsPath = base.getConfig("inputsDir") / self.sourceToken["accref"]
					
					hdus = pyfits.open(fitsPath)
					ax = utils.getWCSAxis(hdus[0].header, 1)

					for spec, flux in enumerate(hdus[0].data):
					  yield {"spectral": math.exp(ax.pix0ToPhys(spec)), "flux": flux}
					hdus.close()
				</code>
			</iterator>
		</embeddedGrammar>
		<make table="instance">
			<parmaker>
				<apply procDef="//ssap#feedSSAToSDM"/>
			</parmaker>
		</make>
	</data>

	<service id="sdl" allowed="dlget,dlmeta,static">
		<meta name="title">\schema Datalink Service</meta>
		<property name="staticData">data</property>
		<datalinkCore>
			<descriptorGenerator procDef="//soda#sdm_genDesc">
				<bind key="ssaTD">"\rdId#data"</bind>
			</descriptorGenerator>
			<dataFunction procDef="//soda#sdm_genData">
				<bind key="builder">"\rdId#build_spectrum"</bind>
			</dataFunction>
			<FEED source="//soda#sdm_plainfluxcalib"/>
			<FEED source="//soda#sdm_cutout"/>
			<FEED source="//soda#sdm_format"/>

	 		<metaMaker semantics="#progenitor">
				<code>
					if descriptor.pubDID is None:
						return
					yield descriptor.makeLinkFromFile(
						base.getConfig("inputsDir") / descriptor.accref,
						description="Spectrum as the original 1D array")
				</code>
			</metaMaker>

		</datalinkCore>
	</service>

	<!-- a form-based service – this is made totally separate from the
	SSA part because grinding down SSA to something human-consumable and
	still working as SSA is non-trivial -->
	<service id="web" defaultRenderer="form">
		<meta name="shortName">\schema Web</meta>
		<meta name="title">\schema Spectra Web Search</meta>

		<dbCore queriedTable="data">
			<condDesc buildFrom="ssa_location"/>
			<condDesc buildFrom="ssa_dateObs"/>
			<!-- add further condDescs in this pattern; if you have useful target
			names, you'll probably want to index them and say:

			<condDesc>
				<inputKey original="data.ssa_targname" tablehead="Standard Stars">
					<values fromdb="ssa_targname from \schema.data
						order by ssa_targname"/>
				</inputKey>
			</condDesc> -->
		</dbCore>

		<outputTable>
			<autoCols>accref, mime, ssa_targname,
				ssa_dateObs, datalink</autoCols>
			<FEED source="//ssap#atomicCoords"/>
			<outputField original="ssa_specstart" displayHint="spectralUnit=Angstrom"/>
			<outputField original="ssa_specend" displayHint="spectralUnit=Angstrom"/>
		</outputTable>
	</service>


	<service id="ssa" allowed="form,ssap.xml">
		<meta name="shortName">\schema SSAP</meta>
		<meta name="ssap.complianceLevel">full</meta>

		<publish render="ssap.xml" sets="ivo_managed"/>
		<publish render="form" sets="ivo_managed,local" service="web"/>

		<ssapCore queriedTable="data">
			<property key="previews">auto</property>
			<FEED source="//ssap#hcd_condDescs"/>
		</ssapCore>
	</service>

	<regSuite title="hermes regression">
		<!-- see http://docs.g-vo.org/DaCHS/ref.html#regression-testing
			for more info on these. -->

		<regTest title="hermes SSAP serves some data">
			<url REQUEST="queryData" PUBDID="%a value you have in ssa_pubDID%"
				>ssa/ssap.xml</url>
			<code>
				<!-- to figure out some good strings to use here, run
					dachs test -k SSAP -D tmp.xml q
					and look at tmp.xml -->
				self.assertHasStrings(
					"%some characteristic string returned by the query%",
					"%another characteristic string returned by the query%")
			</code>
		</regTest>

		<regTest title="hermes Datalink metadata looks about right.">
			<url ID="%a value you have in ssa_pubDID%"
				>sdl/dlmeta</url>
			<code>
				<!-- to figure out good items to test here, you probably want to
					dachs test -k datalink  q
					and pprint the by_sem dict -->
					by_sem = self.datalinkBySemantics()
					print(by_sem)
					self.fail("Fill this in")
			</code>
		</regTest>

		<regTest title="hermes delivers some data.">
			<url ID="%a value you have in ssa_pubDID%"
				>sdl/dlget</url>
			<code>
				<!-- to figure out some good strings to use here, run
					dachs test -k "delivers data" -D tmp.xml q
					and look at tmp.xml -->
				self.assertHasStrings(
					"%some characteristic string in the datalink meta%")
			</code>
		</regTest>

		<!-- add more tests: form-based service renders custom widgets, etc. -->
	</regSuite>
</resource>
