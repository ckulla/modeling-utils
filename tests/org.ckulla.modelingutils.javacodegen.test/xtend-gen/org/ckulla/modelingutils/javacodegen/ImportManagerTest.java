package org.ckulla.modelingutils.javacodegen;

import com.google.inject.Inject;
import org.ckulla.modelingutils.javacodegen.DefaultInjectorProvider;
import org.ckulla.modelingutils.javacodegen.ImportManager;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.junit4.InjectWith;
import org.eclipse.xtext.junit4.XtextRunner;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

@SuppressWarnings("all")
@RunWith(XtextRunner.class)
@InjectWith(DefaultInjectorProvider.class)
public class ImportManagerTest {
  @Inject
  private ImportManager importManager;
  
  @Before
  public void setUp() {
      this.importManager.setPackageName("org.eclipse.foo");
      this.importManager.setClassName("Foo");
  }
  
  @Test
  public void testImportIteself() {
      String _importedName = this.importManager.getImportedName("org.eclipse.foo.Foo");
      Assert.assertEquals("Foo", _importedName);
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string = _importDeclarations.toString();
      Assert.assertEquals("", _string);
  }
  
  @Test
  public void testImportClassInSamePackage() {
      String _importedName = this.importManager.getImportedName("org.eclipse.foo.Bar");
      Assert.assertEquals("Bar", _importedName);
      String _importedName_1 = this.importManager.getImportedName("org.eclipse.foo.Bar");
      Assert.assertEquals("Bar", _importedName_1);
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string = _importDeclarations.toString();
      Assert.assertEquals("", _string);
  }
  
  @Test
  public void testImportClassInOtherPackage() {
      String _importedName = this.importManager.getImportedName("org.eclipse.bar.Bar");
      Assert.assertEquals("Bar", _importedName);
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string = _importDeclarations.toString();
      Assert.assertEquals("import org.eclipse.bar.Bar;\n", _string);
  }
  
  @Test
  public void testImportSameClassInDifferentPackages() {
      String _importedName = this.importManager.getImportedName("org.eclipse.foo.Bar");
      Assert.assertEquals("Bar", _importedName);
      String _importedName_1 = this.importManager.getImportedName("org.eclipse.bar.Bar");
      Assert.assertEquals("org.eclipse.bar.Bar", _importedName_1);
      String _importedName_2 = this.importManager.getImportedName("org.eclipse.foo.Bar");
      Assert.assertEquals("Bar", _importedName_2);
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string = _importDeclarations.toString();
      Assert.assertEquals("", _string);
  }
  
  @Test
  public void testImportSameClassInDifferentPackages2() {
      String _importedName = this.importManager.getImportedName("org.eclipse.bar.Bar");
      Assert.assertEquals("Bar", _importedName);
      String _importedName_1 = this.importManager.getImportedName("org.eclipse.foo.Bar");
      Assert.assertEquals("org.eclipse.foo.Bar", _importedName_1);
      String _importedName_2 = this.importManager.getImportedName("org.eclipse.bar.Bar");
      Assert.assertEquals("Bar", _importedName_2);
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string = _importDeclarations.toString();
      Assert.assertEquals("import org.eclipse.bar.Bar;\n", _string);
  }
  
  @Test
  public void testImportFromMultiplePackages() {
      String _importedName = this.importManager.getImportedName("org.eclipse.bar.Bar");
      Assert.assertEquals("Bar", _importedName);
      String _importedName_1 = this.importManager.getImportedName("org.eclipse.baz.Baz");
      Assert.assertEquals("Baz", _importedName_1);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import org.eclipse.bar.Bar;");
      _builder.newLine();
      _builder.newLine();
      _builder.append("import org.eclipse.baz.Baz;");
      _builder.newLine();
      String _string = _builder.toString();
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string_1 = _importDeclarations.toString();
      Assert.assertEquals(_string, _string_1);
  }
  
  @Test
  public void testImportInnerClass() {
      String _importedName = this.importManager.getImportedName("org.eclipse.bar.Bar$Baz");
      Assert.assertEquals("Bar.Baz", _importedName);
      String _importedName_1 = this.importManager.getImportedName("org.eclipse.bar.Bar$Baz");
      Assert.assertEquals("Bar.Baz", _importedName_1);
      String _importedName_2 = this.importManager.getImportedName("org.eclipse.bar.Bar.Baz");
      Assert.assertEquals("Baz", _importedName_2);
      String _importedName_3 = this.importManager.getImportedName("org.eclipse.bar.Bar$Baz");
      Assert.assertEquals("Baz", _importedName_3);
      String _importedName_4 = this.importManager.getImportedName("org.eclipse.baz.Bar$Baz");
      Assert.assertEquals("org.eclipse.baz.Bar.Baz", _importedName_4);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import org.eclipse.bar.Bar;");
      _builder.newLine();
      _builder.newLine();
      _builder.append("import org.eclipse.bar.Bar.Baz;");
      _builder.newLine();
      String _string = _builder.toString();
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string_1 = _importDeclarations.toString();
      Assert.assertEquals(_string, _string_1);
  }
  
  @Test
  public void testStaticImports() {
      String _staticImportedName = this.importManager.staticImportedName("org.junit.Assert.assertEquals");
      Assert.assertEquals("assertEquals", _staticImportedName);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import static org.junit.Assert.assertEquals;");
      _builder.newLine();
      String _string = _builder.toString();
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string_1 = _importDeclarations.toString();
      Assert.assertEquals(_string, _string_1);
  }
  
  @Test
  public void testStaticImportsWithWildcard() {
      this.importManager.addStaticImport("org.junit.Assert.*");
      String _staticImportedName = this.importManager.staticImportedName("org.junit.Assert.assertEquals");
      Assert.assertEquals("assertEquals", _staticImportedName);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import static org.junit.Assert.*;");
      _builder.newLine();
      String _string = _builder.toString();
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string_1 = _importDeclarations.toString();
      Assert.assertEquals(_string, _string_1);
  }
  
  @Test
  public void testStaticDuplicates() {
      String _staticImportedName = this.importManager.staticImportedName("org.junit.Assert.assertEquals");
      Assert.assertEquals("assertEquals", _staticImportedName);
      String _staticImportedName_1 = this.importManager.staticImportedName("org.junit.Bssert.assertEquals");
      Assert.assertEquals("org.junit.Bssert.assertEquals", _staticImportedName_1);
      String _staticImportedName_2 = this.importManager.staticImportedName("org.junit.Cssert.assertNotEquals");
      Assert.assertEquals("assertNotEquals", _staticImportedName_2);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import static org.junit.Assert.assertEquals;");
      _builder.newLine();
      _builder.newLine();
      _builder.append("import static org.junit.Cssert.assertNotEquals;");
      _builder.newLine();
      String _string = _builder.toString();
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string_1 = _importDeclarations.toString();
      Assert.assertEquals(_string, _string_1);
  }
  
  @Test
  public void testStaticFromDefiningClass() {
      String _staticImportedName = this.importManager.staticImportedName("org.eclipse.foo.Foo.assertEquals");
      Assert.assertEquals("assertEquals", _staticImportedName);
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string = _importDeclarations.toString();
      Assert.assertEquals("", _string);
  }
}
