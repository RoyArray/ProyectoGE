<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmEmpleados.aspx.cs" Inherits="ProyectoGE.Pages.frmEmpleados" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ingreso de Empleados</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>Ingreso de Empleados</h2>

            Nombre:<br />
            <asp:TextBox ID="txtNombre" runat="server"></asp:TextBox><br />

            Apellido:<br />
            <asp:TextBox ID="txtApellido" runat="server"></asp:TextBox><br />

            Fecha de Nacimiento:<br />
            <asp:TextBox ID="txtFechaNacimiento" runat="server" TextMode="Date"></asp:TextBox><br />

            Teléfono:<br />
            <asp:TextBox ID="txtTelefono" runat="server"></asp:TextBox><br />

            Correo Electrónico:<br />
            <asp:TextBox ID="txtCorreo" runat="server" TextMode="Email"></asp:TextBox><br />

            Dirección:<br />
            <asp:TextBox ID="txtDireccion" runat="server"></asp:TextBox><br />

            Fecha de Ingreso:<br />
            <asp:TextBox ID="txtFechaIngreso" runat="server" TextMode="Date"></asp:TextBox><br />

            Salario:<br />
            <asp:TextBox ID="txtSalario" runat="server" TextMode="Number"></asp:TextBox><br />

            Departamento:<br />
            <asp:DropDownList ID="ddlDepartamento" runat="server">
                <asp:ListItem Text="Seleccione un departamento" Value=""></asp:ListItem>
                <asp:ListItem Text="Recursos Humanos" Value="1"></asp:ListItem>
                <asp:ListItem Text="Tecnología" Value="2"></asp:ListItem>
                <asp:ListItem Text="Finanzas" Value="3"></asp:ListItem>
                <asp:ListItem Text="Marketing" Value="4"></asp:ListItem>
            </asp:DropDownList><br /><br />

            <asp:Button ID="btnGuardar" runat="server" Text="Guardar Empleado" OnClick="btnGuardar_Click" />
        </div>
    </form>
</body>
</html>
