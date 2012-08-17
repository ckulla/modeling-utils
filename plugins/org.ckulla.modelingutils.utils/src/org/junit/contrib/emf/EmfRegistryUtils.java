package org.junit.contrib.emf;

import java.util.HashMap;

import org.eclipse.emf.codegen.ecore.genmodel.GenModelPackage;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EValidator;
import org.eclipse.emf.ecore.EcorePackage;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.xmi.impl.EcoreResourceFactoryImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

/**
 * 
 * Utility for tests to avoid being based on and doing any side effects to the
 * global registries from EMF.
 * 
 * @author Sven Efftinge - Initial contribution and API
 * @author Christoph Kulla - Renamed into EmfRegistryUtils
 */
public class EmfRegistryUtils {

	public static class EmfRegistryState {
		private final HashMap<EPackage, Object> validatorReg;
		private final HashMap<String, Object> epackageReg;
		private final HashMap<String, Object> protocolToFactoryMap;
		private final HashMap<String, Object> extensionToFactoryMap;
		private final HashMap<String, Object> contentTypeIdentifierToFactoryMap;

		public EmfRegistryState() {
			validatorReg = new HashMap<EPackage, Object> (EValidator.Registry.INSTANCE);
			epackageReg = new HashMap<String, Object> (EPackage.Registry.INSTANCE);
			protocolToFactoryMap = new HashMap<String, Object> (
						Resource.Factory.Registry.INSTANCE.getProtocolToFactoryMap ());
			extensionToFactoryMap = new HashMap<String, Object> (
						Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap ());
			contentTypeIdentifierToFactoryMap = new HashMap<String, Object> (
						Resource.Factory.Registry.INSTANCE.getContentTypeToFactoryMap ());
		}

		public void restore() {
			EValidator.Registry.INSTANCE.clear ();
			EPackage.Registry.INSTANCE.clear ();
			Resource.Factory.Registry.INSTANCE.getProtocolToFactoryMap ().clear ();
			Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap ().clear ();
			Resource.Factory.Registry.INSTANCE.getContentTypeToFactoryMap ().clear ();

			EValidator.Registry.INSTANCE.putAll (validatorReg);
			EPackage.Registry.INSTANCE.putAll (epackageReg);
			Resource.Factory.Registry.INSTANCE.getProtocolToFactoryMap ().putAll (protocolToFactoryMap);
			Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap ().putAll (extensionToFactoryMap);
			Resource.Factory.Registry.INSTANCE.getContentTypeToFactoryMap ().putAll (contentTypeIdentifierToFactoryMap);
		}
	}

	public static EmfRegistryState copyRegistryState() {
		return new EmfRegistryState ();
	}

	public static void initializeDefaults() {
		// EMF Standalone setup
		if (!Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap ().containsKey ("ecore"))
			Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap ().put ("ecore", new EcoreResourceFactoryImpl ());
		if (!Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap ().containsKey ("xmi"))
			Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap ().put ("xmi", new XMIResourceFactoryImpl ());
		if (!EPackage.Registry.INSTANCE.containsKey (EcorePackage.eNS_URI))
			EPackage.Registry.INSTANCE.put (EcorePackage.eNS_URI, EcorePackage.eINSTANCE);
		if (!EPackage.Registry.INSTANCE.containsKey (GenModelPackage.eNS_URI))
			EPackage.Registry.INSTANCE.put (GenModelPackage.eNS_URI, GenModelPackage.eINSTANCE);

	}

}
