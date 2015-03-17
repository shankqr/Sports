using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Text;
using System.Xml;
using System.Reflection;
using System.Collections;
using System.Web;
using System.Globalization;


internal class StringWriterWithEncoding : StringWriter
{
    Encoding encoding;

    public StringWriterWithEncoding(StringBuilder builder, Encoding encoding): base(builder)
    {
        this.encoding = encoding;
    }

    public override Encoding Encoding
    {
        get { return encoding; }
    }
}

/// <summary>
/// Summary description for PlistDocument
/// </summary>
public class PlistDocument
{
    public PlistDocument()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public static string CreateDocument(object value)
    {
        TextWriter xml = new StringWriterWithEncoding(new StringBuilder(), Encoding.UTF8);
        XmlWriterSettings settings = new XmlWriterSettings();
        settings.NewLineChars = "\r\n";
        settings.IndentChars = "\t";
        settings.Indent = true;
        settings.NewLineHandling = NewLineHandling.Replace;
        XmlWriter writer = XmlTextWriter.Create(xml, settings);

        writer.WriteStartDocument();
        writer.WriteDocType("plist", null, "http://www.apple.com/DTDs/PropertyList-1.0.dtd", null);
        writer.WriteStartElement("plist");
        writer.WriteAttributeString("version", "1.0");

        createDocumentFragment(writer, value);

        writer.WriteEndElement();
        writer.Close();

        return xml.ToString();
    }

    /// <summary>
    /// Creates a valid XML tag pair in the XmlWriter, based upon the object passed in.
    /// </summary>
    /// <param name="writer">The XmlWriter to add the XML Tag.</param>
    /// <param name="value">An object to represent in the PropertyList.</param>
    private static void createDocumentFragment(XmlWriter writer, object value)
    {
        Type objectType = value.GetType();
        Type baseType = objectType.BaseType;
        string objType = value.GetType().FullName;
        string basType = baseType.FullName;

        // An array isn't of a particular type, but needs to be handled separately.
        if (objectType.IsArray)
        {
            objType = "Dummy.Namespace.Array";
        }

        // A dictionary is processed as a series of key value pairs.
        if (
            (objectType.IsGenericType && objType.Contains("Generic.Dictionary")) ||
            (baseType.IsGenericType && basType.Contains("Generic.Dictionary"))
            )
        {
            Dictionary<string, object> dict = createObjectDictionary(value, objectType);

            writer.WriteStartElement("dict");

            // Outputs a key, then value, for each item in the dictionary.
            foreach (KeyValuePair<string, object> item in dict)
            {
                writer.WriteElementString("key", item.Key);
                createDocumentFragment(writer, item.Value);
            }

            writer.WriteEndElement();      // 'dict' element
        }
        else
        {
            // Processing for some standard 'C' wrappers and DataSet/DataTable/DataRows.
            createDocumentFragmentForNonDictionary(writer, value, objectType, objType);
        }
    }

    private static void createDocumentFragmentForNonDictionary(XmlWriter writer, object value, Type objectType, string objType)
    {
        Type baseType = objectType.BaseType;
        string basType = baseType.FullName;

        string stringValue = "";

        if (objType.Equals("System.String"))
        {
            stringValue = value.ToString();
            writer.WriteElementString("string", stringValue);
        }
        else if (objType.Contains("System.Int"))
        {
            stringValue = value.ToString();
            double d = double.Parse(stringValue);
            if (d == 0)
            {
                stringValue = "0";
            }
            else
            {
                stringValue = d.ToString(); //d.ToString("#,#", CultureInfo.InvariantCulture);
            }
            writer.WriteElementString("string", stringValue);
        }
        else if (objType.Equals("System.Boolean"))
        {
            bool boolValue = Convert.ToBoolean(value);
            writer.WriteElementString("string", boolValue.ToString());
        }
        else if (objType.Equals("System.Single") || objType.Equals("System.Double") || objType.Equals("System.Decimal"))
        {
            stringValue = value.ToString();
            writer.WriteElementString("string", stringValue);
        }
        else if (objType.Equals("System.DateTime"))
        {
            DateTime date = Convert.ToDateTime(value);
            string dateValue, timeValue;

            dateValue = date.ToString("D");
            timeValue = date.ToString("HH:mm:ss");

            stringValue = dateValue + ' ' + timeValue;
            writer.WriteElementString("string", stringValue);
        }
        else if (objType.Equals("System.Data.DataSet") || objType.Equals("System.Data.DataTable") || objType.Equals("System.Data.DataRow"))
        {
            createDocumentFragmentFromDataObject(writer, value);
        }
        else if (objType.Equals("Dummy.Namespace.Array"))
        {
            object[] arr = value as object[];
            writer.WriteStartElement("array");

            foreach (object obj in arr)
            {
                createDocumentFragment(writer, obj);
            }

            writer.WriteEndElement();       // 'array' tag
        }
        else if (
            (objectType.IsGenericType && objType.Contains("Generic.List")) ||
            (baseType.IsGenericType && basType.Contains("Generic.List"))
            )
        {
            MethodInfo theMethod = objectType.GetMethod("ToArray");

            object array = theMethod.Invoke(value, null);
            object[] arr = array as object[];

            if (arr != null)
            {
                writer.WriteStartElement("array");

                foreach (object obj in arr)
                {
                    createDocumentFragment(writer, obj);
                }

                writer.WriteEndElement();       // 'array' tag
            }
        }
        else
        {
            if (objectType.IsSerializable)
            {
                // If the object is serializable, retrieves the public properties
                // and creates a 'dict' element containing all of them.
                // The class does NOT have to be marked as Serializable for this to work.
                System.Reflection.PropertyInfo[] propertyInfo = objectType.GetProperties();

                writer.WriteStartElement("dict");

                // Outputs a key then value for each public property.
                // The order of output is the same as their definition in source code.
                for (int index = 0; index < propertyInfo.Length; index++)
                {
                    writer.WriteElementString("key", propertyInfo[index].Name);
                    createDocumentFragment(writer, propertyInfo[index].GetValue(value, null));
                }

                writer.WriteEndElement();       // 'dict' tag
            }
        }
    }

    private static Dictionary<string, object> createObjectDictionary(object value, Type objectType)
    {
        PropertyInfo keysProperty = objectType.GetProperty("Keys");
        PropertyInfo valuesProperty = objectType.GetProperty("Values");

        object objKeys = keysProperty.GetValue(value, null);
        object objValues = valuesProperty.GetValue(value, null);

        Dictionary<string, object> dict = new Dictionary<string, object>();

        ICollection keyCollection = objKeys as ICollection;
        int count = keyCollection.Count;

        string[] keyArray = new string[count];
        object[] valueArray = new object[count];

        keyCollection.CopyTo(keyArray, 0);
        ((ICollection)objValues).CopyTo(valueArray, 0);

        for (int index = 0; index < keyArray.Length; index++)
        {
            dict.Add(keyArray[index], valueArray[index]);
        }

        return dict;
    }


    /// <summary>
    /// Creates a valid XML tag pair in the XmlWriter, based upon the Data object passed in.
    /// This is used internally for a DataSet, DataTable or DataRow
    /// </summary>
    /// <param name="writer">The XmlWriter to add the XML Tag.</param>
    /// <param name="value">An object to represent in the PropertyList.</param>
    private static void createDocumentFragmentFromDataObject(XmlWriter writer, object value)
    {
        Type objectType = value.GetType();

        // Creates an array of DataTables.
        if (objectType.Equals(typeof(System.Data.DataSet)))
        {
            DataSet dataset = value as DataSet;

            writer.WriteStartElement("array");

            foreach (DataTable table in dataset.Tables)
            {
                createDocumentFragmentFromDataObject(writer, table);
            }

            writer.WriteEndElement();       // 'array' tag
        }
        else if (objectType.Equals(typeof(System.Data.DataTable)))
        {
            // Creates an array of DataRows.
            DataTable table = value as DataTable;

            writer.WriteStartElement("array");

            foreach (DataRow row in table.Rows)
            {
                createDocumentFragmentFromDataObject(writer, row);
            }

            writer.WriteEndElement();       // 'array' tag
        }
        else if (objectType.Equals(typeof(System.Data.DataRow)))
        {
            // With the DataRows we need to cater for potential DBNull values.
            // This needs to be handled on a per-type basis, as most cannot be null.
            DataRow row = value as DataRow;

            writer.WriteStartElement("dict");

            foreach (DataColumn column in row.Table.Columns)
            {
                string objType = column.DataType.ToString();
                bool isNull = row[column].Equals(DBNull.Value);

                writer.WriteElementString("key", column.ColumnName);

                if (objType.Equals("System.String"))
                {
                    createDocumentFragment(writer, row[column].ToString());
                }
                else if (objType.StartsWith("System.Int16") || objType.StartsWith("System.Int32") || objType.StartsWith("System.Int64"))
                {
                    if (isNull)
                    {
                        createDocumentFragment(writer, 0);
                    }
                    else
                    {
                        Int64 intData = Convert.ToInt64(row[column]);
                        createDocumentFragment(writer, intData);
                    }
                }
                else if (objType.Equals("System.Boolean"))
                {
                    if (isNull)
                    {
                        createDocumentFragment(writer, false);
                    }
                    else
                    {
                        bool boolData = Convert.ToBoolean(row[column]);
                        createDocumentFragment(writer, boolData);
                    }
                }
                else if (objType.Equals("System.Single") || objType.Equals("System.Double") || objType.Equals("System.Decimal"))
                {
                    if (isNull)
                    {
                        createDocumentFragment(writer, (decimal)0);
                    }
                    else
                    {
                        // Decimal will retain the precision of a Single (float) or Double, but not vice-versa.
                        Decimal decimalData = Convert.ToDecimal(row[column]);
                        createDocumentFragment(writer, decimalData);
                    }
                }
                else if (objType.Equals("System.DateTime"))
                {
                    if (isNull)
                    {
                        createDocumentFragment(writer, DateTime.MinValue);
                    }
                    else
                    {
                        DateTime dateData = Convert.ToDateTime(row[column]);
                        createDocumentFragment(writer, dateData);
                    }
                }
            }

            writer.WriteEndElement();        // 'dict' Tag
        }
    }
}
