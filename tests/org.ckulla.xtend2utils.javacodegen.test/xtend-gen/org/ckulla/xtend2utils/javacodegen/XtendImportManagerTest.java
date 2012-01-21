package org.ckulla.xtend2utils.javacodegen;

import com.google.inject.Inject;
import org.ckulla.xtend2utils.javacodegen.DefaultInjectorProvider;
import org.ckulla.xtend2utils.javacodegen.XtendImportManager;
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
public class XtendImportManagerTest {
  @Inject
  private XtendImportManager importManager;
  
  @Before
  public void setUp() {
      this.importManager.setPackageName("org.eclipse.foo");
      this.importManager.setClassName("Foo");
  }
  
  @Test
  public void testImportClassInOtherPackage() {
      String _importedName = this.importManager.getImportedName("org.eclipse.bar.Bar");
      Assert.assertEquals("Bar", _importedName);
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string = _importDeclarations.toString();
      Assert.assertEquals("import org.eclipse.bar.Bar\n", _string);
  }
  
  @Test
  public void testStaticImports() {
      String _staticImportedName = this.importManager.staticImportedName("org.junit.Assert.assertEquals");
      Assert.assertEquals("assertEquals", _staticImportedName);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import static org.junit.Assert.assertEquals");
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
      Assert.assertEquals("org::junit::Bssert::assertEquals", _staticImportedName_1);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import static org.junit.Assert.assertEquals");
      _builder.newLine();
      String _string = _builder.toString();
      CharSequence _importDeclarations = this.importManager.getImportDeclarations();
      String _string_1 = _importDeclarations.toString();
      Assert.assertEquals(_string, _string_1);
  }
}
