<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frmEmpleados.aspx.cs" Inherits="ProyectoGE.Pages.frmEmpleados" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Empleados</title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Button ID="btnCargar" runat="server" Text="Cargar Empleados" OnClick="btnCargar_Click" />
        <asp:GridView ID="gvEmpleados" runat="server" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField HeaderText="ID" DataField="IdEmpleado" />
                <asp:BoundField HeaderText="Nombre" DataField="Nombre" />
                <asp:BoundField HeaderText="Apellido" DataField="Apellido" />
                <asp:BoundField HeaderText="Correo" DataField="Correo" />
                <asp:BoundField HeaderText="Departamento" DataField="IdDepartamento" />
                <asp:BoundField HeaderText="Ingreso" DataField="FechaIngreso" DataFormatString="{0:yyyy-MM-dd}" />
                <asp:BoundField HeaderText="Salario" DataField="Salario" DataFormatString="{0:N2}" />
            </Columns>
        </asp:GridView>
        <asp:Label ID="lblTotal" runat="server" />
    </form>
</body>
</html>
