package dddsample;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.file.Files;
import java.util.Map;
import java.util.Properties;

import javax.persistence.EntityManagerFactory;
import javax.persistence.spi.PersistenceProvider;
import javax.persistence.spi.PersistenceUnitInfo;
import javax.persistence.spi.ProviderUtil;

import org.hibernate.jpa.HibernatePersistenceProvider;
import org.jboss.vfs.VirtualFile;

import com.redhat.ceylon.compiler.java.runtime.tools.Backend;
import com.redhat.ceylon.compiler.java.runtime.tools.CeylonToolProvider;
import com.redhat.ceylon.compiler.java.runtime.tools.Runner;
import com.redhat.ceylon.compiler.java.runtime.tools.RunnerOptions;


public class CeylonInit implements PersistenceProvider {
 
	//private static Boolean initialized = false;
	
	static {
		postConstruct();
	}
	
	private final PersistenceProvider delegate;
	public CeylonInit(){
		delegate = new HibernatePersistenceProvider();
	}
	
    
	
    @Override
	public EntityManagerFactory createContainerEntityManagerFactory( PersistenceUnitInfo info, Map map) {
		return delegate.createContainerEntityManagerFactory(info, map);
	}

    @Override
	public EntityManagerFactory createEntityManagerFactory(String emName, Map map) {
		return delegate.createEntityManagerFactory(emName, map);
	}
	
	@Override
	public void generateSchema(PersistenceUnitInfo arg0, Map arg1) {
		delegate.generateSchema(arg0, arg1);
		
	}

	@Override
	public boolean generateSchema(String arg0, Map arg1) {
		return delegate.generateSchema(arg0, arg1);
	}

	@Override
	public ProviderUtil getProviderUtil() {
		return delegate.getProviderUtil();
	}

	private static void postConstruct() {
		
		try{
		URL url = CeylonInit.class.getProtectionDomain().getCodeSource().getLocation().toURI().resolve("../..").toURL();
		//System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>" + url);
		 URLConnection conn = url.openConnection();
		 initialize(url.toURI());
		}catch(Exception e){
			throw new IllegalStateException(e);
		}
		
	}
	
	public static void initialize(URI warRoot) throws Exception {
		if (runner != null) {
			return;
		}
		final File repo = setupRepo(warRoot);
		final Properties properties = moduleProperties(warRoot);
		final RunnerOptions options = new RunnerOptions();
		
		options.setOffline(true);
		options.setSystemRepository("flat:" + repo.getAbsolutePath());
		
		runner = CeylonToolProvider.getRunner(Backend.Java, options, 
				properties.getProperty("moduleName"),
				properties.getProperty("moduleVersion"));
	}

	protected static File setupRepo(URI warRoot) {
		try {
			final URL libDir = warRoot.resolve("WEB-INF/lib").toURL();
			if (libDir.getProtocol().equals("file")) {
				
				return new File(libDir.toURI());
			} else {
				// we're running from the WAR, and need to extract a repo to disk
				final URL libList = warRoot.resolve("META-INF/libs.txt").toURL();
				tmpRepo = Files.createTempDirectory("ceylon_war_repo").toFile();
				
				try (BufferedReader reader = new BufferedReader(new InputStreamReader(libList.openStream()))) {
					String filename;
					while ((filename = reader.readLine()) != null) {
						URL url = warRoot.resolve("WEB-INF/lib/" + filename).toURL();
						
						copy(url, new File(tmpRepo, filename));
						//System.out.println(url + " " + new File(tmpRepo, filename).length());
					}
				}
			
				return tmpRepo;
			}				

		} catch (IOException|URISyntaxException e) {
			throw new RuntimeException(e);
		}
	}
	
	protected static Properties moduleProperties(URI warRoot) throws Exception {
		final Properties properties = new Properties();
		URL modulePropUrl = warRoot.resolve("META-INF/module.properties").toURL();
		System.out.println(modulePropUrl);
		try (InputStream moduleProps = modulePropUrl.openStream()) {
			properties.load(moduleProps);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
		
		return properties;
	}
	
	protected static void copy(final URL src, final File dest) throws IOException {
		URLConnection conn = src.openConnection();
		VirtualFile virtualFile = (VirtualFile) conn.getContent();
		File srcFile = virtualFile.getPhysicalFile();
		srcFile = srcFile.getParentFile();
		srcFile = new File(srcFile, virtualFile.getName());
		//System.out.println("+++" + srcFile);
		Files.copy(srcFile.toPath(), dest.toPath());
	}
	
	private static File tmpRepo;
	private static Runner runner;
	
	

	
	
}
