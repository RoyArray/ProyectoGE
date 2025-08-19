using System;
using System.Data.SqlClient;
using System.Configuration;

namespace ProyectoGE.Models
{
    public class ConexionDB
    {
        private readonly string connectionString;

        public ConexionDB()
        {
            // Lee la cadena de conexión desde Web.config
            connectionString = ConfigurationManager.ConnectionStrings["GestionEmpleadosDB"].ConnectionString;
        }

        // Devuelve una conexión lista para usarse
        public SqlConnection ObtenerConexion()
        {
            return new SqlConnection(connectionString);
        }
    }
}
 