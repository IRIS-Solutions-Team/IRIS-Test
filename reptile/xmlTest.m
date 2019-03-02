
delete test.html

x = com.mathworks.xml.XMLUtils.createDocument('html');
impl = x.getImplementation( );
docType = impl.createDocumentType('html', 'SYSTEM', 'root.dtd');
x.appendChild(docType);

c = xmlwrite(x)

