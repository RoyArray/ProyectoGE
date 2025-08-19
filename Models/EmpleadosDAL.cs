using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;

namespace ProyectoGE.Models
{
    public class EmpleadoDto
    {
        public int IdEmpleado { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Correo { get; set; }
        public int IdDepartamento { get; set; }
        public DateTime? FechaIngreso { get; set; }
        public decimal? Salario { get; set; }
    }

    public class PagedResult<T>
    {
        public int Total { get; set; }
        public List<T> Items { get; set; } = new List<T>();
    }

    public class EmpleadoDAL
    {
        private readonly ConexionDB _db = new ConexionDB();

        public PagedResult<EmpleadoDto> Listar(int? idDepartamento, string buscar, int page = 1, int pageSize = 20)
        {
            var result = new PagedResult<EmpleadoDto>();

            using (var conn = _db.ObtenerConexion())
            using (var cmd = new SqlCommand("dbo.Empleado_List", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdDepartamento", (object)idDepartamento ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Buscar", (object)buscar ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Page", page);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);

                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    // 1er resultset: Total
                    if (rdr.Read()) result.Total = rdr.GetInt32(0);

                    // 2do resultset: Items
                    if (rdr.NextResult())
                    {
                        while (rdr.Read())
                        {
                            result.Items.Add(new EmpleadoDto
                            {
                                IdEmpleado = rdr.GetInt32(rdr.GetOrdinal("IdEmpleado")),
                                Nombre = rdr["Nombre"] as string,
                                Apellido = rdr["Apellido"] as string,
                                Correo = rdr["Correo"] as string,
                                IdDepartamento = rdr.GetInt32(rdr.GetOrdinal("IdDepartamento")),
                                FechaIngreso = rdr["FechaIngreso"] as DateTime?,
                                Salario = rdr["Salario"] as decimal?
                            });
                        }
                    }
                }
            }
            return result;
        }

        public int Insertar(string nombre, string apellido, DateTime? fechaNac, string telefono,
                            string correo, string direccion, DateTime? fechaIngreso,
                            decimal? salario, int idDepartamento, string adicionadoPor)
        {
            using (var conn = _db.ObtenerConexion())
            using (var cmd = new SqlCommand("dbo.Empleado_Insert", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Nombre", nombre);
                cmd.Parameters.AddWithValue("@Apellido", apellido);
                cmd.Parameters.AddWithValue("@FechaNacimiento", (object)fechaNac ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Telefono", (object)telefono ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Correo", (object)correo ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Direccion", (object)direccion ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@FechaIngreso", (object)fechaIngreso ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Salario", (object)salario ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@IdDepartamento", idDepartamento);
                cmd.Parameters.AddWithValue("@Adicionado_Por", (object)adicionadoPor ?? DBNull.Value);

                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()); // SCOPE_IDENTITY()
            }
        }

        public int Actualizar(int idEmpleado, string nombre, string apellido, DateTime? fechaNac, string telefono,
                              string correo, string direccion, DateTime? fechaIngreso,
                              decimal? salario, int idDepartamento, string modificadoPor)
        {
            using (var conn = _db.ObtenerConexion())
            using (var cmd = new SqlCommand("dbo.Empleado_Update", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado);
                cmd.Parameters.AddWithValue("@Nombre", nombre);
                cmd.Parameters.AddWithValue("@Apellido", apellido);
                cmd.Parameters.AddWithValue("@FechaNacimiento", (object)fechaNac ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Telefono", (object)telefono ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Correo", (object)correo ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Direccion", (object)direccion ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@FechaIngreso", (object)fechaIngreso ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Salario", (object)salario ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@IdDepartamento", idDepartamento);
                cmd.Parameters.AddWithValue("@Modificado_Por", (object)modificadoPor ?? DBNull.Value);

                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()); // @@ROWCOUNT
            }
        }

        public int Eliminar(int idEmpleado)
        {
            using (var conn = _db.ObtenerConexion())
            using (var cmd = new SqlCommand("dbo.Empleado_Delete", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IdEmpleado", idEmpleado);
                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()); // @@ROWCOUNT
            }
        }
    }
}
