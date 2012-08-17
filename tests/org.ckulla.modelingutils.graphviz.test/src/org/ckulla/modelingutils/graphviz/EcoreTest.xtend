package org.ckulla.modelingutils.graphviz

import static org.junit.Assert.*

import org.eclipse.emf.ecore.EcorePackage
import org.ckulla.modelingutils.graphviz.EcoreToGraph
import org.ckulla.modelingutils.graphviz.GraphToDot
import org.junit.Test
import org.junit.contrib.guice.GuiceRule
import org.junit.contrib.rules.Rules
import org.junit.contrib.rules.RulesTestRunner
import org.junit.runner.RunWith

import com.google.inject.Inject

@RunWith(typeof (RulesTestRunner))
@Rules({ typeof(GuiceRule) })
class EcoreTest {
	
	@Inject
	EcoreToGraph ecoreToGraph
	
	@Inject
	GraphToDot graph2Dot
	
	@Test
	def void test() {
		val graph = ecoreToGraph.toGraph(EcorePackage::eINSTANCE);
		assertEquals (
			'''
				digraph "ecore" {
				
					graph [ fontname = "arial" ]
					node [ fontname = "arial" ]
					edge [ fontname = "arial" ]
					
					subgraph "cluster_ecore" {
						label="ecore";name="ecore";fontname="arial";
						
						0 [shape=record,label="{EAttribute}",fillcolor=grey,fontcolor=black,style=filled, bold];
						1 [shape=record,label="{EAnnotation}",fillcolor=grey,fontcolor=black,style=filled, bold];
						2 [shape=record,label="{EClass|EBoolean isSuperTypeOf(EClass someClass)\lEInt getFeatureCount()\lEStructuralFeature getEStructuralFeature(EInt featureID)\lEInt getFeatureID(EStructuralFeature feature)\lEStructuralFeature getEStructuralFeature(EString featureName)\lEInt getOperationCount()\lEOperation getEOperation(EInt operationID)\lEInt getOperationID(EOperation operation)\lEOperation getOverride(EOperation operation)\l}",fillcolor=grey,fontcolor=black,style=filled, bold];
						3 [shape=record,label="{\<\<abstract\>\>\nEClassifier|EBoolean isInstance(EJavaObject object)\lEInt getClassifierID()\l}",fillcolor=white,fontcolor=black,style=filled, bold];
						4 [shape=record,label="{EDataType}",fillcolor=grey,fontcolor=black,style=filled, bold];
						5 [shape=record,label="{EEnum|EEnumLiteral getEEnumLiteral(EString name)\lEEnumLiteral getEEnumLiteral(EInt value)\lEEnumLiteral getEEnumLiteralByLiteral(EString literal)\l}",fillcolor=grey,fontcolor=black,style=filled, bold];
						6 [shape=record,label="{EEnumLiteral}",fillcolor=grey,fontcolor=black,style=filled, bold];
						7 [shape=record,label="{EFactory|EObject create(EClass eClass)\lEJavaObject createFromString(EDataType eDataTypeEString literalValue)\lEString convertToString(EDataType eDataTypeEJavaObject instanceValue)\l}",fillcolor=grey,fontcolor=black,style=filled, bold];
						8 [shape=record,label="{\<\<abstract\>\>\nEModelElement|EAnnotation getEAnnotation(EString source)\l}",fillcolor=white,fontcolor=black,style=filled, bold];
						9 [shape=record,label="{\<\<abstract\>\>\nENamedElement}",fillcolor=white,fontcolor=black,style=filled, bold];
						10 [shape=record,label="{EObject|EClass eClass()\lEBoolean eIsProxy()\lEResource eResource()\lEObject eContainer()\lEStructuralFeature eContainingFeature()\lEReference eContainmentFeature()\lEEList eContents()\lETreeIterator eAllContents()\lEEList eCrossReferences()\lEJavaObject eGet(EStructuralFeature feature)\lEJavaObject eGet(EStructuralFeature featureEBoolean resolve)\l eSet(EStructuralFeature featureEJavaObject newValue)\lEBoolean eIsSet(EStructuralFeature feature)\l eUnset(EStructuralFeature feature)\lEJavaObject eInvoke(EOperation operationEEList arguments)throwsEInvocationTargetException\l}",fillcolor=grey,fontcolor=black,style=filled, bold];
						11 [shape=record,label="{EOperation|EInt getOperationID()\lEBoolean isOverrideOf(EOperation someOperation)\l}",fillcolor=grey,fontcolor=black,style=filled, bold];
						12 [shape=record,label="{EPackage|EClassifier getEClassifier(EString name)\l}",fillcolor=grey,fontcolor=black,style=filled, bold];
						13 [shape=record,label="{EParameter}",fillcolor=grey,fontcolor=black,style=filled, bold];
						14 [shape=record,label="{EReference}",fillcolor=grey,fontcolor=black,style=filled, bold];
						15 [shape=record,label="{\<\<abstract\>\>\nEStructuralFeature|EInt getFeatureID()\lEJavaClass getContainerClass()\l}",fillcolor=white,fontcolor=black,style=filled, bold];
						16 [shape=record,label="{\<\<abstract\>\>\nETypedElement}",fillcolor=white,fontcolor=black,style=filled, bold];
						17 [shape=record,label="{EStringToStringMapEntry}",fillcolor=grey,fontcolor=black,style=filled, bold];
						18 [shape=record,label="{EGenericType}",fillcolor=grey,fontcolor=black,style=filled, bold];
						19 [shape=record,label="{ETypeParameter}",fillcolor=grey,fontcolor=black,style=filled, bold];
						20 [shape=record,label="{EBigDecimal|}",fillcolor= white,fontcolor=black,style=filled, bold];
						21 [shape=record,label="{EBigInteger|}",fillcolor= white,fontcolor=black,style=filled, bold];
						22 [shape=record,label="{EBoolean|}",fillcolor= white,fontcolor=black,style=filled, bold];
						23 [shape=record,label="{EBooleanObject|}",fillcolor= white,fontcolor=black,style=filled, bold];
						24 [shape=record,label="{EByte|}",fillcolor= white,fontcolor=black,style=filled, bold];
						25 [shape=record,label="{EByteArray|}",fillcolor= white,fontcolor=black,style=filled, bold];
						26 [shape=record,label="{EByteObject|}",fillcolor= white,fontcolor=black,style=filled, bold];
						27 [shape=record,label="{EChar|}",fillcolor= white,fontcolor=black,style=filled, bold];
						28 [shape=record,label="{ECharacterObject|}",fillcolor= white,fontcolor=black,style=filled, bold];
						29 [shape=record,label="{EDate|}",fillcolor= white,fontcolor=black,style=filled, bold];
						30 [shape=record,label="{EDiagnosticChain|}",fillcolor= white,fontcolor=black,style=filled, bold];
						31 [shape=record,label="{EDouble|}",fillcolor= white,fontcolor=black,style=filled, bold];
						32 [shape=record,label="{EDoubleObject|}",fillcolor= white,fontcolor=black,style=filled, bold];
						33 [shape=record,label="{EEList|}",fillcolor= white,fontcolor=black,style=filled, bold];
						34 [shape=record,label="{EEnumerator|}",fillcolor= white,fontcolor=black,style=filled, bold];
						35 [shape=record,label="{EFeatureMap|}",fillcolor= white,fontcolor=black,style=filled, bold];
						36 [shape=record,label="{EFeatureMapEntry|}",fillcolor= white,fontcolor=black,style=filled, bold];
						37 [shape=record,label="{EFloat|}",fillcolor= white,fontcolor=black,style=filled, bold];
						38 [shape=record,label="{EFloatObject|}",fillcolor= white,fontcolor=black,style=filled, bold];
						39 [shape=record,label="{EInt|}",fillcolor= white,fontcolor=black,style=filled, bold];
						40 [shape=record,label="{EIntegerObject|}",fillcolor= white,fontcolor=black,style=filled, bold];
						41 [shape=record,label="{EJavaClass|}",fillcolor= white,fontcolor=black,style=filled, bold];
						42 [shape=record,label="{EJavaObject|}",fillcolor= white,fontcolor=black,style=filled, bold];
						43 [shape=record,label="{ELong|}",fillcolor= white,fontcolor=black,style=filled, bold];
						44 [shape=record,label="{ELongObject|}",fillcolor= white,fontcolor=black,style=filled, bold];
						45 [shape=record,label="{EMap|}",fillcolor= white,fontcolor=black,style=filled, bold];
						46 [shape=record,label="{EResource|}",fillcolor= white,fontcolor=black,style=filled, bold];
						47 [shape=record,label="{EResourceSet|}",fillcolor= white,fontcolor=black,style=filled, bold];
						48 [shape=record,label="{EShort|}",fillcolor= white,fontcolor=black,style=filled, bold];
						49 [shape=record,label="{EShortObject|}",fillcolor= white,fontcolor=black,style=filled, bold];
						50 [shape=record,label="{EString|}",fillcolor= white,fontcolor=black,style=filled, bold];
						51 [shape=record,label="{ETreeIterator|}",fillcolor= white,fontcolor=black,style=filled, bold];
						52 [shape=record,label="{EInvocationTargetException|}",fillcolor= white,fontcolor=black,style=filled, bold];
					}
					0 -> 22 [dir=both,label=iD,arrowtail=diamond,arrowhead=none,weight=25];
					0 -> 4 [dir=both,label=eAttributeType,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="1"];
					1 -> 50 [dir=both,label=source,arrowtail=diamond,arrowhead=none,weight=25];
					1 -> 17 [dir=both,label=details,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					1 -> 8 [dir=both,label=eModelElement,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					1 -> 10 [dir=both,label=contents,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					1 -> 10 [dir=both,label=references,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					2 -> 22 [dir=both,label=abstract,arrowtail=diamond,arrowhead=none,weight=25];
					2 -> 22 [dir=both,label=interface,arrowtail=diamond,arrowhead=none,weight=25];
					2 -> 2 [dir=both,label=eSuperTypes,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					2 -> 11 [dir=both,label=eOperations,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					2 -> 0 [dir=both,label=eAllAttributes,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					2 -> 14 [dir=both,label=eAllReferences,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					2 -> 14 [dir=both,label=eReferences,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					2 -> 0 [dir=both,label=eAttributes,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					2 -> 14 [dir=both,label=eAllContainments,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					2 -> 11 [dir=both,label=eAllOperations,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					2 -> 15 [dir=both,label=eAllStructuralFeatures,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					2 -> 2 [dir=both,label=eAllSuperTypes,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					2 -> 0 [dir=both,label=eIDAttribute,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					2 -> 15 [dir=both,label=eStructuralFeatures,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					2 -> 18 [dir=both,label=eGenericSuperTypes,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					2 -> 18 [dir=both,label=eAllGenericSuperTypes,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					3 -> 50 [dir=both,label=instanceClassName,arrowtail=diamond,arrowhead=none,weight=25];
					3 -> 41 [dir=both,label=instanceClass,arrowtail=diamond,arrowhead=none,weight=25];
					3 -> 42 [dir=both,label=defaultValue,arrowtail=diamond,arrowhead=none,weight=25];
					3 -> 50 [dir=both,label=instanceTypeName,arrowtail=diamond,arrowhead=none,weight=25];
					3 -> 12 [dir=both,label=ePackage,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					3 -> 19 [dir=both,label=eTypeParameters,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					4 -> 22 [dir=both,label=serializable,arrowtail=diamond,arrowhead=none,weight=25];
					5 -> 6 [dir=both,label=eLiterals,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					6 -> 39 [dir=both,label=value,arrowtail=diamond,arrowhead=none,weight=25];
					6 -> 34 [dir=both,label=instance,arrowtail=diamond,arrowhead=none,weight=25];
					6 -> 50 [dir=both,label=literal,arrowtail=diamond,arrowhead=none,weight=25];
					6 -> 5 [dir=both,label=eEnum,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					7 -> 12 [dir=both,label=ePackage,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="1"];
					8 -> 1 [dir=both,label=eAnnotations,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					9 -> 50 [dir=both,label=name,arrowtail=diamond,arrowhead=none,weight=25];
					11 -> 2 [dir=both,label=eContainingClass,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					11 -> 19 [dir=both,label=eTypeParameters,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					11 -> 13 [dir=both,label=eParameters,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					11 -> 3 [dir=both,label=eExceptions,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					11 -> 18 [dir=both,label=eGenericExceptions,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					12 -> 50 [dir=both,label=nsURI,arrowtail=diamond,arrowhead=none,weight=25];
					12 -> 50 [dir=both,label=nsPrefix,arrowtail=diamond,arrowhead=none,weight=25];
					12 -> 7 [dir=both,label=eFactoryInstance,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="1"];
					12 -> 3 [dir=both,label=eClassifiers,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					12 -> 12 [dir=both,label=eSubpackages,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					12 -> 12 [dir=both,label=eSuperPackage,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					13 -> 11 [dir=both,label=eOperation,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					14 -> 22 [dir=both,label=containment,arrowtail=diamond,arrowhead=none,weight=25];
					14 -> 22 [dir=both,label=container,arrowtail=diamond,arrowhead=none,weight=25];
					14 -> 22 [dir=both,label=resolveProxies,arrowtail=diamond,arrowhead=none,weight=25];
					14 -> 14 [dir=both,label=eOpposite,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					14 -> 2 [dir=both,label=eReferenceType,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="1"];
					14 -> 0 [dir=both,label=eKeys,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="*"];
					15 -> 22 [dir=both,label=changeable,arrowtail=diamond,arrowhead=none,weight=25];
					15 -> 22 [dir=both,label=volatile,arrowtail=diamond,arrowhead=none,weight=25];
					15 -> 22 [dir=both,label=transient,arrowtail=diamond,arrowhead=none,weight=25];
					15 -> 50 [dir=both,label=defaultValueLiteral,arrowtail=diamond,arrowhead=none,weight=25];
					15 -> 42 [dir=both,label=defaultValue,arrowtail=diamond,arrowhead=none,weight=25];
					15 -> 22 [dir=both,label=unsettable,arrowtail=diamond,arrowhead=none,weight=25];
					15 -> 22 [dir=both,label=derived,arrowtail=diamond,arrowhead=none,weight=25];
					15 -> 2 [dir=both,label=eContainingClass,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					16 -> 22 [dir=both,label=ordered,arrowtail=diamond,arrowhead=none,weight=25];
					16 -> 22 [dir=both,label=unique,arrowtail=diamond,arrowhead=none,weight=25];
					16 -> 39 [dir=both,label=lowerBound,arrowtail=diamond,arrowhead=none,weight=25];
					16 -> 39 [dir=both,label=upperBound,arrowtail=diamond,arrowhead=none,weight=25];
					16 -> 22 [dir=both,label=many,arrowtail=diamond,arrowhead=none,weight=25];
					16 -> 22 [dir=both,label=required,arrowtail=diamond,arrowhead=none,weight=25];
					16 -> 3 [dir=both,label=eType,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					16 -> 18 [dir=both,label=eGenericType,arrowtail=diamond,arrowhead=none,weight=50,headlabel="0..1"];
					17 -> 50 [dir=both,label=key,arrowtail=diamond,arrowhead=none,weight=25];
					17 -> 50 [dir=both,label=value,arrowtail=diamond,arrowhead=none,weight=25];
					18 -> 18 [dir=both,label=eUpperBound,arrowtail=diamond,arrowhead=none,weight=50,headlabel="0..1"];
					18 -> 18 [dir=both,label=eTypeArguments,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					18 -> 3 [dir=both,label=eRawType,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="1"];
					18 -> 18 [dir=both,label=eLowerBound,arrowtail=diamond,arrowhead=none,weight=50,headlabel="0..1"];
					18 -> 19 [dir=both,label=eTypeParameter,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					18 -> 3 [dir=both,label=eClassifier,arrowtail=ediamond,arrowhead=none,weight=1,headlabel="0..1"];
					19 -> 18 [dir=both,label=eBounds,arrowtail=diamond,arrowhead=none,weight=50,headlabel="*"];
					15 -> 0 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					8 -> 1 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					3 -> 2 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					9 -> 3 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					3 -> 4 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					4 -> 5 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					9 -> 6 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					8 -> 7 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					8 -> 9 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					16 -> 11 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					9 -> 12 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					16 -> 13 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					15 -> 14 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					16 -> 15 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					9 -> 16 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
					9 -> 19 [dir=both,arrowtail=empty,arrowhead=none,weight=100];
				}
			'''.toString,
			graph2Dot.toDot(graph, "ecore").toString
		);
	}
	
}